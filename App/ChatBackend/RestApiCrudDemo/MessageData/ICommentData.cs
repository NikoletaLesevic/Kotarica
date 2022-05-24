using ChatBackend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ChatBackend.MessageData
{
    public interface ICommentData
    {
        List<Comment> DajKomentare(string nazivOglasa);

        Comment DodajKomentar(Comment comment);

        void DeleteComment(String id,String username);
    }
}
