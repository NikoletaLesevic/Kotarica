using ChatBackend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ChatBackend.MessageData
{
    public class SqlWishData : IWishData
    {
        private MessageContext _messageContext;

        public SqlWishData(MessageContext messageContext)
        {
            _messageContext = messageContext;
        }

        public Wish AddWish(Wish wish)
        {
            wish.Id = Guid.NewGuid();
            _messageContext.Wishes.Add(wish);
            _messageContext.SaveChanges();
            Console.WriteLine("Wish je sacuvan");
            return wish;
        }

        public void DeleteWish(string id)
        {
            List<Wish> wishes = _messageContext.Wishes.ToList();
            foreach (var w in wishes)
            {
                if (w.Id.ToString().Equals(id))
                {
                    wishes.Remove(w);
                    Console.WriteLine("BRISEM WISH");
                    _messageContext.Remove(w);
                    _messageContext.SaveChanges();
                    return;
                }
            }
        }

        public void DeleteWishByUsernameAndAdName(string username, string adName)
        {
            List<Wish> wishes = _messageContext.Wishes.ToList();
            foreach (var w in wishes)
            {
                if (w.username.Equals(username) && w.adName.Equals(adName))
                {
                    wishes.Remove(w);
                    Console.WriteLine("BRISEM WISH");
                    _messageContext.Remove(w);
                    _messageContext.SaveChanges();
                    return;
                }
            }
        }

        public List<Wish> GetWishesByUsername(string username)
        {
            List<Wish> wishes = _messageContext.Wishes.ToList();
            List<Wish> result = new List<Wish>();

            foreach(var w in wishes)
            {
                if (w.username.Equals(username))
                {
                    result.Add(w);
                }
            }

            return result;
        }

       
    }
}
