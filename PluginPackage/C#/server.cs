using System.Collections.Generic;
using System.IO;
using System.Net.Http;
using System.Threading.Tasks;
using System.Diagnostics;
using System;
using System.Runtime.InteropServices;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Server.Kestrel.Core;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Hosting;
using Microsoft.AspNetCore.Hosting.Server.Features;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Extensions;


public class Server
{   

    public void Configure(IApplicationBuilder app, Microsoft.Extensions.Hosting.IHostApplicationLifetime lifeTime)
        {
            var serverAddressesFeature = 
                app.ServerFeatures.Get<IServerAddressesFeature>();

            app.UseStaticFiles();

            app.Run(async (context) =>
            {
                context.Response.ContentType = "text/html";
                await context.Response
                    .WriteAsync("<!DOCTYPE html><html lang=\"en\"><head>" +
                        "<title></title></head><body><p>Hosted by Kestrel</p>");

                if (serverAddressesFeature != null)
                {
                    await context.Response
                        .WriteAsync("<p>Listening on the following addresses: " +
                            string.Join(", ", serverAddressesFeature.Addresses) +
                            "</p>");
                }

                await context.Response.WriteAsync("<p>Request URL: " +
                    $"{context.Request.GetDisplayUrl()}<p>");
                string url = context.Request.GetDisplayUrl();
                RequestToken(url);
                lifeTime.StopApplication();
            });
        }
    private static readonly HttpClient client = new HttpClient();
    private static string clientID;
    private static string redirectUri;
    private static string localUrl;

    private static async Task RequestToken(string url)
    {
        UriBuilder response = new UriBuilder(url);
        string code = response.Query;
        if(!code.StartsWith("?code="))
            return;
        int index = code.IndexOf("&");
        if (index == -1)
        {
            code = code.Substring(6);
        }
        else
        {
            string state = code.Substring(index);
            code = code.Substring(6,index-6);
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

    public static void StartServer()
    {
        CreateHostBuilder().Build().Run();
    }
    public static IHostBuilder CreateHostBuilder(params string[] args) =>
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
                .UseStartup<Server>();
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

    public static void OpenBrowser(string url)
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
