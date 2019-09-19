using System.Collections.Generic;
using System.IO;
using System.Net.Http;
using System.Threading.Tasks;
using System;


public class Server
{   
    private static readonly HttpClient client = new HttpClient();

    public static async Task GetToken(string remoteUrl, string responseType, string clientID, string redirectUri, string scope, string localUrl)
    {
        UriBuilder uri = new UriBuilder(remoteUrl);
        uri.Query = "response_type="+ responseType + "&client_id=" + clientID + "&redirect_uri=" + redirectUri + "&scope=" + scope;
        Process.Start(GetDefaultBrowserPath(), uri.Uri);

        using (HttpResponseMessage responseMessage = await client.GetAsync(uri.Uri).ConfigureAwait(false))
        {
            if (responseMessage.IsSuccessStatusCode)
            {
                string content = await responseMessage.Content.ReadAsStringAsync().ConfigureAwait(false);
                UriBuilder response = new UriBuilder(content);
                string code = response.Query;
                string state;
                //TODO: check state

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
                        string contentToken = await responseMessage.Content.ReadAsStringAsync().ConfigureAwait(false);
                        System.IO.File.WriteAllText(localUrl,contentToken);
                    }
                }

                
            }
        }        

    }

    public static async Task DownloadFileAsync(string remoteUrl, string localUrl)
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
}
