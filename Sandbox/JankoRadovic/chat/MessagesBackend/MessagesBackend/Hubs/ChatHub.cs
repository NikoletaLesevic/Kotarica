using Microsoft.AspNetCore.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MessagesBackend.Hubs
{
    public class ChatHub : Hub
    {
        public async Task ChatFromServer(string firstUser, string secondUser, string message)
        {
            await Clients.Others.SendAsync("ReceiveNewMessage", firstUser, secondUser, message);
            Console.WriteLine("Received message from server app " + firstUser + " " + secondUser + " " + message);
        }
    }
}
