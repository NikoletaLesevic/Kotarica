using ChatBackend.MessageData;
using ChatBackend.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ChatBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class WishController : Controller
    {
        private IWishData _wishData;

        public WishController(IWishData wishData)
        {
            _wishData = wishData;
        }

        [HttpGet]
        [Route("/api/wish/{username}")]
        public IActionResult GetWishes(string username)
        {
            Console.WriteLine("DAJEM ZELJE");
            var wishes = _wishData.GetWishesByUsername(username);
            if (wishes != null)
            {
                return Ok(wishes);
            }

            return NotFound($"Wishes : ${username} not found");
        }

        [HttpPost]
        [Route("/api/wish")]
        public void AddWish(Wish wish)
        {
            Console.WriteLine("DODAJEM WISH");
            _wishData.AddWish(wish);

            //return Created(HttpContext.Request.Scheme + "://" + HttpContext.Request.Host + HttpContext.Request.Path + "/" + message.Id + message);
        }

        [HttpDelete]
        [Route("/api/wish/{id}")]
        public void DeleteComment(String id)
        {
            Console.WriteLine("Delete wish with id " + id);
            _wishData.DeleteWish(id);
        }

        [HttpDelete]
        [Route("/api/wish/delete/{username}/{adName}")]
        public void DeleteCommentByUsernameAndAdName(String username, String adName)
        {
            Console.WriteLine("Delete wish");
            _wishData.DeleteWishByUsernameAndAdName(username, adName);
        }
    }
}
