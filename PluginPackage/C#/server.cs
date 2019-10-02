using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using System.Diagnostics;
using System;
using System.Runtime.InteropServices;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Hosting;
using Microsoft.AspNetCore.Hosting.Server.Features;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Extensions;

namespace Ctest
{

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
                if(query.StartsWith("?code="))
                {
                    _ = Server.RequestToken(query);
                    await context.Response.WriteAsync("<span>Authorization Complete!</span><h3>Return to 3ds Max to begin your export!</h3>");
                }
                else
                {
                    await context.Response.WriteAsync("<h2>Authorization Denied!</h2>");
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
                Console.WriteLine("Start");
                Server.GetToken(@"https://cesium.com/ion/oauth","code",args[1],args[2],"assets:write",args[3]).Wait();
                Console.WriteLine("End");
            }
        }

    
    private static readonly HttpClient client = new HttpClient();
    private static string clientID;
    private static string redirectUri;
    private static string localUrl;

    public static async Task RequestToken(string query)
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
        { "redirect_uri", redirectUri }
        };
        var POSTContent = new FormUrlEncodedContent(parameters);

        using (HttpResponseMessage responseMessageToken = await client.PostAsync(tokenUri,POSTContent).ConfigureAwait(false))
        {
            if (responseMessageToken.IsSuccessStatusCode)
            {
                string contentToken = await responseMessageToken.Content.ReadAsStringAsync().ConfigureAwait(false);
                System.IO.File.WriteAllText(localUrl,contentToken);
            }
        }
    }

    private static void StartServer()
    {
        CreateHostBuilder().Build().Run();
    }
    private static IHostBuilder CreateHostBuilder(params string[] args) =>
        Host.CreateDefaultBuilder(args)
            .ConfigureWebHostDefaults(webBuilder =>
            {
                webBuilder.ConfigureKestrel(serverOptions =>
                {
                    serverOptions.ConfigureEndpointDefaults(listenOptions =>
                    {
                    // Configure endpoint defaults
                    });
                })
                .UseStartup<StartUp>();
            });

    public static async Task GetToken(string remoteUrl, string responseType, string clientID, string redirectUri, string scope, string localUrl)
    {
        Server.redirectUri = redirectUri;
        Server.clientID = clientID;
        Server.localUrl = localUrl;
        Uri uri = new Uri(remoteUrl);
        string query = "?response_type="+ Uri.EscapeDataString(responseType) + "&client_id=" + Uri.EscapeDataString(clientID) 
        + "&redirect_uri=" + Uri.EscapeDataString(redirectUri) + "&scope=" + Uri.EscapeDataString(scope);
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

 /*   public static async Task DownloadFileAsync(string remoteUrl, string localUrl)
    {
        using (HttpResponseMessage responseMessage = await client.GetAsync(remoteUrl).ConfigureAwait(false))
        {
            if (responseMessage.IsSuccessStatusCode)
            {
                var byteArray = await responseMessage.Content.ReadAsByteArrayAsync().ConfigureAwait(false);
                using (FileStream filestream = new FileStream(localUrl, FileMode.Create, FileAccess.Write, FileShare.None, bufferSize:4096, useAsync:true))
                {
                    await filestream.WriteAsync(byteArray, 0, byteArray.Length);
                }
            }
        }        
    }

    public static async Task DownloadMultipleFilesAsync(string[] remoteUrl, string[] localUrl)
    {
        List allTasks = new List();
        for (int n = 0; n < remoteUrl.Length; n++)
        {
            allTasks.Add(DownloadFileAsync(remoteUrl[n], localUrl[n]));
        }
        await Task.WhenAll(allTasks).ConfigureAwait(false);
    }
    */
}
}
