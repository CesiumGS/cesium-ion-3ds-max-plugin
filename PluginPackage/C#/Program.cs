using System;
using System.Threading.Tasks;
using System.Diagnostics;

namespace C_
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Start");
            Server.GetToken(@"https://cesium.com/ion/oauth","code","56",@"http://localhost:5000/","assets:write",@"C:\Users\Patrick\Desktop\test.txt").Wait();
            Console.WriteLine("End");
        }
    }
}
