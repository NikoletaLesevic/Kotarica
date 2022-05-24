using ChatBackend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ChatBackend.MessageData
{
    public class SqlUserData : IUserData
    {
        private MessageContext _messageContext;

        public SqlUserData(MessageContext messageContext)
        {
            _messageContext = messageContext;
        }
        public User createUser(User user)
        {
            Console.WriteLine("CUVA SE USER SA USERNAMOM " + user.username);
            user.Id = Guid.NewGuid();
            _messageContext.Users.Add(user);
            _messageContext.SaveChanges();
            Console.WriteLine("SACUVAN JE USER SA USERNAMOM " + user.username);
            return user;
        }

        
    }
}
