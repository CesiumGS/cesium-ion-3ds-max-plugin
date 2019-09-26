using System;
using System.Diagnostics;
//using Microsoft.CodeAnalysis.CSharp.Scripting;

namespace Ctest
{
    static class Program
    {
        static void Main(string[] args)
        {
            if (args.Length >= 3)
            {
                Console.WriteLine("Start");
                Server.GetToken(@"https://cesium.com/ion/oauth","code",args[0],args[1],"assets:write",args[2]).Wait();
                Console.WriteLine("End");
            }
            /*Assembly test = Assembly.LoadFrom(@"C:\Users\Patrick\Documents\reps\cesium-ion-3ds-max-plugin\PluginPackage\C#\C#.dll");
            var debug = test.GetTypes();
            MethodInfo m = test.GetType("Server").GetMethod("GetToken");
            Object[] parameters = {@"https://cesium.com/ion/oauth","code","56",@"http://localhost:5000/","assets:write",@"C:\Users\Patrick\Desktop\test.txt"};
            m.Invoke(null,parameters);*/
            /*CSharpCodeProvider csharpProvider = new CSharpCodeProvider();
            CompilerParameters compilerParams = new CompilerParameters();
            string[] depend = {"System.Collections.dll", "System.Net.Http.dll", "System.Threading.Tasks.dll", "System.Runtime.dll",
             "System.Diagnostics.Process.dll", "System.dll", "System.Runtime.Extensions.dll", "System.Runtime.dll", 
             "System.Runtime.InteropServices.RuntimeInformation.dll", "Microsoft.AspNetCore.Hosting.Abstractions.dll",
              "Microsoft.AspNetCore.Http.Abstractions.dll", "Microsoft.Extensions.Hosting.Abstractions.dll",
               "Microsoft.AspNetCore.Hosting.Server.Abstractions.dll","mscorlib.dll", "netstandard.dll", "System.Management.dll"};
            string[] depend2 = {"System.Net.Http.dll","System.dll", "System.Management.dll"};
            compilerParams.ReferencedAssemblies.AddRange(depend);
		    compilerParams.GenerateInMemory = true;
            string[] file = {@"C:\Users\Patrick\Documents\reps\cesium-ion-3ds-max-plugin\PluginPackage\server.cs"};
            string[] source = {strAssembly};
            //var result = csharpProvider.CompileAssemblyFromFile(compilerParams,file);
            //var server = result.CompiledAssembly.CreateInstance("Server");
            object result = CSharpScript.EvaluateAsync("1 + 2");
*/
        } 
    }
}
