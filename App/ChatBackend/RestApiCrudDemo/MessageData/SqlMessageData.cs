using ChatBackend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ChatBackend.MessageData
{
    public class SqlMessageData : IMessageData
    {
        private MessageContext _messageContext;

        public SqlMessageData(MessageContext messageContext)
        {
            _messageContext = messageContext;
        }

        public Message AddMessage(Message message)
        {
            DateTime now = DateTime.Now;
            Console.WriteLine(now);
            message.Id = Guid.NewGuid();
            message.date = now;
            _messageContext.Messages.Add(message);
            _messageContext.SaveChanges();
            return message;
        }

        public List<Message> GetChat(string firstUser, string secondUser)
        {
            List<Message> messages = _messageContext.Messages.ToList();
            List<Message> result = new List<Message>();

            foreach(var m in messages)
            {
                if((m.sender == firstUser && m.receiver == secondUser) || (m.sender == secondUser && m.receiver == firstUser))
                {
                    result.Add(m);
                }
            }

            result.Sort((x, y) => DateTime.Compare(y.date, x.date));
            return result;
        }

        public List<Message> GetMessages(string user)
        {
            var messages = _messageContext.Messages.ToList();
            HashSet<string> set = new HashSet<string>();
            List<Message> result = new List<Message>();
            foreach (Message m in messages)
            {
                if (m.sender == user || m.receiver == user)
                {
                    string otherUser = m.sender == user ? m.receiver : m.sender;
                    if(!set.Contains(otherUser))
                    {
                        result.Add(m);
                        set.Add(otherUser);
                    }
                    
                }
            }

            result.Sort((x, y) => DateTime.Compare(y.date, x.date));
            return result;
        }
    }
}
