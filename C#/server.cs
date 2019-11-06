using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using System.Diagnostics;
using System;
using System.Threading;
using System.Runtime.InteropServices;
using System.Text;
using System.Json;
using System.Security.Cryptography;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Hosting;
using Microsoft.AspNetCore.Hosting.Server.Features;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Extensions;
using Amazon.S3.Transfer;
using Amazon.S3;
using Amazon.Runtime;


public class RandomString
{
    internal static readonly char[] chars =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890".ToCharArray(); 

    public static string GetUniqueString(int size)
    {            
        byte[] data = new byte[4*size];
        using (RNGCryptoServiceProvider crypto = new RNGCryptoServiceProvider())
        {
            crypto.GetBytes(data);
        }
        StringBuilder result = new StringBuilder(size);
        for (int i = 0; i < size; i++)
        {
            var rnd = BitConverter.ToUInt32(data, i * 4);
            var idx = rnd % chars.Length;

            result.Append(chars[idx]);
        }

        return result.ToString();
    }
}
public class StartUp
{
    public void Configure(IApplicationBuilder app, Microsoft.Extensions.Hosting.IHostApplicationLifetime lifeTime)
    {
        var serverAddressesFeature = 
            app.ServerFeatures.Get<IServerAddressesFeature>();

        app.UseStaticFiles();

        app.Run(async (context) =>
        {
            context.Response.ContentType = "text/html";
            string url = context.Request.GetDisplayUrl();
            Uri response = new Uri(url);
            string query = response.Query;
            string htmlFile = "%RESPONSE%";
            try
            {
                htmlFile = System.IO.File.ReadAllText("index.html");
            }
            catch (Exception)
            {

            }

            if(query.StartsWith("?code="))
            {
                bool success = await Server.RequestToken(query);
                if (success)
                {
                    await context.Response.WriteAsync(htmlFile.Replace("%RESPONSE%","<span>Authorization Complete!</span><h3>Return to 3ds Max to begin your export!</h3>"));
                }
                else
                {
                    await context.Response.WriteAsync(htmlFile.Replace("%RESPONSE%","<h2>Authorization Denied!</h2>"));
                }

            }
            else
            {
                await context.Response.WriteAsync(htmlFile.Replace("%RESPONSE%","<h2>Authorization Denied!</h2>"));
            }
            
            lifeTime.StopApplication();
        });
    }
}
static public class Server
{   
    static void Main(string[] args)
    {
        if (args.Length >= 4 && args[0] == "gettoken")
        {
            Console.WriteLine("Start gettoken");      
            Server.GetToken(@"https://cesium.com/ion/oauth","code",args[1],args[2],"assets:write",args[3]).Wait(1000*60*5);
            Console.WriteLine("End");
        }
        if (args.Length >= 9 && args[0] == "upload")
        {
            Console.WriteLine("Start Upload");
            Server.Upload(args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]).Wait();
            Console.WriteLine("Upload finished");
        }
    }

    
    private static readonly HttpClient client = new HttpClient();
    private static string clientID;
    private static string redirectUri;
    private static string localUrl;
    private static string codeVerifier;

    public static async Task<bool> RequestToken(string query)
    {
        int index = query.IndexOf("&");
        string code;
        if (index == -1)
        {
            code = query.Substring(6);
        }
        else
        {
            string state = query.Substring(index);
            code = query.Substring(6,index-6);
            //TODO: check state
        } 

        Uri tokenUri = new Uri("https://api.cesium.com/oauth/token");
        Dictionary<string, string> parameters = new Dictionary<string, string>
        {
        { "grant_type", "authorization_code" },
        { "client_id", clientID },
        { "code", code },
        { "redirect_uri", redirectUri },
        { "code_verifier", codeVerifier}
        };
        var POSTContent = new FormUrlEncodedContent(parameters);

        using (HttpResponseMessage responseMessageToken = await client.PostAsync(tokenUri,POSTContent).ConfigureAwait(false))
        {
            if (responseMessageToken.IsSuccessStatusCode)
            {
                string contentToken = await responseMessageToken.Content.ReadAsStringAsync().ConfigureAwait(false);
                System.IO.File.WriteAllText(localUrl,contentToken);
                return true;
            }
        }
        return false;
    }

    private static void StartServer()
    {
        try
        {
            CreateHostBuilder().Build().Run();
        }
        catch (Exception e)
        {
            Console.WriteLine("Could not create local server. Message:'{0}'", e.Message);
        }
    }
    private static IHostBuilder CreateHostBuilder(params string[] args) =>
        Host.CreateDefaultBuilder(args)
            .ConfigureWebHostDefaults(webBuilder =>
            {
                webBuilder.UseStartup<StartUp>();
            });

    public static async Task GetToken(string remoteUrl, string responseType, string clientID, string redirectUri, string scope, string localUrl)
    {
        Server.redirectUri = redirectUri;
        Server.clientID = clientID;
        Server.localUrl = localUrl;
        SHA256 encrypter = SHA256.Create();
        codeVerifier = RandomString.GetUniqueString(32);
        var hashed = encrypter.ComputeHash(Encoding.UTF8.GetBytes(codeVerifier));
        var encoded = Convert.ToBase64String(hashed);
        string codeChallenge = encoded.Replace("=","").Replace('+','-').Replace('/','_');
        Uri uri = new Uri(remoteUrl);
        string query = "?response_type="+ Uri.EscapeDataString(responseType) + "&client_id=" + Uri.EscapeDataString(clientID) 
        + "&redirect_uri=" + Uri.EscapeDataString(redirectUri) + "&scope=" + Uri.EscapeDataString(scope)
        + "&code_challenge=" + codeChallenge + "&code_challenge_method=S256";
        uri = new Uri(uri,query);
        Task thread = Task.Factory.StartNew(()=>StartServer());
        OpenBrowser(uri.ToString());
        await thread;
    }

    private static void OpenBrowser(string url)
    {
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            url = url.Replace("&", "^&");
            Process.Start(new ProcessStartInfo("cmd", $"/c start {url}"));
        }
        else if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
        {
            Process.Start("xdg-open", url);
        }
        else if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
        {
            Process.Start("open", url);
        }
    }

    public static async Task Upload(string filePath, string name, string description, string attribution, string sourceType, string textureFormat, string tokenPath, string logPath)
    {
        string content = String.Format(
        @"{{""name"": ""{0}"", ""description"": ""{1}"", ""attribution"": ""{2}"", ""type"": ""3DTILES"", ""options"": {{""sourceType"": ""{3}"", ""textureFormat"": ""{4}""}} }}",
        name,description,attribution,sourceType,textureFormat);
        var POSTContent = new StringContent(content, Encoding.UTF8, "application/json");
        string token = System.IO.File.ReadAllText(tokenPath);
        JsonObject json = JsonValue.Parse(token) as JsonObject;
        client.DefaultRequestHeaders.Add("Authorization","Bearer " + (string)json["access_token"]);
        client.DefaultRequestHeaders.Add("json", "true");

        Uri requestUri = new Uri("https://api.cesium.com/v1/assets");

        using (HttpResponseMessage responseMessage = await client.PostAsync(requestUri, POSTContent))
        {
            if (responseMessage.IsSuccessStatusCode)
            {
                string responseContent = await responseMessage.Content.ReadAsStringAsync().ConfigureAwait(false);
                JsonObject responseJson = JsonValue.Parse(responseContent) as JsonObject;
                JsonObject uploadLocation = responseJson["uploadLocation"] as JsonObject;
                JsonObject onComplete = responseJson["onComplete"] as JsonObject;
                try 
                {
                    SessionAWSCredentials credentials = new SessionAWSCredentials(
                        (string)uploadLocation["accessKey"],
                        (string)uploadLocation["secretAccessKey"],
                        (string)uploadLocation["sessionToken"]);
                    using (var s3Client = new AmazonS3Client(credentials,Amazon.RegionEndpoint.USEast1))
                    using (var fileTransferUtility = new TransferUtility(s3Client))
                    {
                        var uploadRequest = new TransferUtilityUploadRequest
                        {
                            FilePath = filePath,
                            BucketName = uploadLocation["bucket"],
                            Key = uploadLocation["prefix"] + name + ".fbx"
                        };

                        uploadRequest.UploadProgressEvent += (sender, args) =>
                        {
                            System.IO.File.WriteAllText(logPath, $"{args.TransferredBytes}/{args.TotalBytes}");
                        };

                        await fileTransferUtility.UploadAsync(uploadRequest);
                        var completeContent = new StringContent(onComplete["fields"].ToString(), Encoding.UTF8, "application/json");
                        await client.PostAsync((string)onComplete["url"],completeContent);
                        string id = (string)uploadLocation["prefix"];
                        id = id.Substring(id.IndexOf("/"));
                        OpenBrowser(@"https://cesium.com/ion/assets" + id);
                        Thread.Sleep(10);
                    } 
                }
                catch (AmazonS3Exception e)
                {
                   System.IO.File.WriteAllText(logPath, String.Format("Error encountered on server. Message:'{0}' when writing an object", e.Message));
                }
                catch (Exception e)
                {
                    System.IO.File.WriteAllText(logPath, String.Format("Error encountered on server. Message:'{0}' when writing an object", e.Message));
                }
            }
            else
            {
                string error = await responseMessage.Content.ReadAsStringAsync();
                System.IO.File.WriteAllText(logPath, "Error: " + error);
            }
        }
    }
}

