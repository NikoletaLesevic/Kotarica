using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace ChatBackend.Models
{
    public class Message
    {
        [Key]
        public Guid Id { get; set; }

        [Required]
        public string  sender { get; set; }
        [Required]
        public string receiver { get; set; }
        [Required]
        public string message { get; set; }

        public DateTime date { get; set; }
    }
}
