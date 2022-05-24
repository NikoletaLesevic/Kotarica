using ChatBackend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ChatBackend.MessageData
{
    public interface IMessageData
    {
        List<Message> GetMessages(string user);

        Message AddMessage(Message message);

        List<Message> GetChat(string firstUser, string secondUser);
    }
}
