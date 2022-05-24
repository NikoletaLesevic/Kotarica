using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ChatBackend.MessageData;
using ChatBackend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;

namespace ChatBackend.Controllers
{
    
    [Route("api/[controller]")]
    [ApiController]
    public class CommentController : ControllerBase
    {
        private ICommentData _commentData;

        public CommentController(ICommentData commentData)
        {
            _commentData = commentData;
        }

        [HttpGet]
        [Route("/api/komentar/{naziv}")]
        public IActionResult GetComments(string naziv)
        {
            Console.WriteLine("DAJEM KOMENTARE");
            var comments = _commentData.DajKomentare(naziv);
            if (comments != null)
            {
                return Ok(comments);
            }

            return NotFound($"Oglas : ${naziv} not found");
        }

        [Authorize]
        [HttpPost]
        [Route("/api/komentar")]

        public void AddComment(Comment comment)
        {
            Console.WriteLine("DODAJEM KOMENTAR");
            _commentData.DodajKomentar(comment);

            //return Created(HttpContext.Request.Scheme + "://" + HttpContext.Request.Host + HttpContext.Request.Path + "/" + message.Id + message);
        }

        [Authorize]
        [HttpDelete]
        [Route("/api/komentar/{id}")]
        public void DeleteComment(String id)
        {
            string username = HttpContext.User.Identity.Name;
            Console.WriteLine("Delete comment with id " + id);
            _commentData.DeleteComment(id, username);
        }
        
    }
}
