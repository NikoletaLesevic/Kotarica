using ChatBackend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ChatBackend.MessageData
{
    public interface IWishData
    {
        List<Wish> GetWishesByUsername(string username);

        Wish AddWish(Wish wish);

        void DeleteWish(String id);

        void DeleteWishByUsernameAndAdName(String username, String adName);
    }
}
