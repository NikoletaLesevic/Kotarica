using ChatBackend.MessageData;
using ChatBackend.Models;
using Microsoft.AspNetCore.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MessagesBackend.Hubs
{
    public class ChatHub : Hub
    {
        private IMessageData _messageData;

        public ChatHub(IMessageData messageData)
        {
            _messageData = messageData;
        }

        public async Task ChatFromServer(string firstUser, string secondUser, string message)
        {
            _messageData.AddMessage(new Message{sender = firstUser, receiver = secondUser, message = message });
            await Clients.All.SendAsync("ReceiveNewMessage", firstUser, secondUser, message, DateTime.Now);
            Console.WriteLine("Received message from server app " + firstUser + " " + secondUser + " " + message);
        }

        public async Task GoOnline(string user)
        {
            await Clients.All.SendAsync("BeVisible", user);
            Console.WriteLine("User " + user + " is now online");
        }

        public async Task CheckUserStatus(string user)
        {
            await Clients.All.SendAsync("IsUserOnline", user);
            Console.WriteLine("User " + user + " is maybee online");
        }

        public async Task GoOffline(string user)
        {
            await Clients.All.SendAsync("UserOffline", user);
            Console.WriteLine("User " + user + " is ofline");
        }
    }
}
