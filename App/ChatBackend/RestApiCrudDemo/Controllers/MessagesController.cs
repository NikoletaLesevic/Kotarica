using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ChatBackend.MessageData;
using ChatBackend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ChatBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MessagesController : ControllerBase
    {
        private IMessageData _messageData;

        public MessagesController(IMessageData messageData)
        {
            _messageData = messageData;
        }

        [HttpGet]
        [Route("/api/messages/{user}")]

        public IActionResult GetMessages(string user)
        {
            var messages = _messageData.GetMessages(user);
            if(messages != null)
            {
                return Ok(messages);
            }

            return NotFound($"User with username : ${user} not found");
        }

        [HttpGet("/api/chat/{firstUser}/{secondUser}")]

        public IActionResult GetChat(string firstUser, string secondUser)
        {
            var messages = _messageData.GetChat(firstUser, secondUser);
            if (messages != null)
            {
                return Ok(messages);
            }

            return NotFound($"Not found");
        }

        [HttpPost]
        [Route("/api/messages")]

        public void AddMessage(Message message)
        {
            _messageData.AddMessage(message);
            
            //return Created(HttpContext.Request.Scheme + "://" + HttpContext.Request.Host + HttpContext.Request.Path + "/" + message.Id + message);
        }
    }
}
