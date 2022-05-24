using ChatBackend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ChatBackend.MessageData
{
    public class SqlCommentData : ICommentData
    {
        private MessageContext _messageContext;

        public SqlCommentData(MessageContext messageContext)
        {
            _messageContext = messageContext;
        }
        public List<Comment> DajKomentare(string nazivOglasa)
        {
            List<Comment> comments = _messageContext.Comments.ToList();
            List<Comment> result = new List<Comment>();

            foreach(var c in comments)
            {
                if(c.nazivOglasa.Equals(nazivOglasa))
                {
                    result.Add(c);
                }
            }

            return result;
        }

        public void DeleteComment(string id, string username)
        {
            List<Comment> comments = _messageContext.Comments.ToList();
            foreach (var c in comments)
            {
                if (c.Id.ToString().Equals(id) && c.korisnik.Equals(username))
                {
                    comments.Remove(c);
                    Console.WriteLine("BRISEM KOMENTAR");
                    _messageContext.Remove(c);
                    _messageContext.SaveChanges();
                    return;
                }
            }
           // _messageContext.Remove(_messageContext.Comments.Single(a => a.Id.ToString().Equals(id) && a.korisnik.Equals(username)));
            
        }

        public Comment DodajKomentar(Comment comment)
        {
            comment.Id = Guid.NewGuid();
            _messageContext.Comments.Add(comment);
            _messageContext.SaveChanges();
            Console.WriteLine("SACUVAN JE KOMENTAR");
            return comment;
        }
    }
}
