using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace ChatBackend.Models
{
    public class Wish
    {
        [Key]
        public Guid Id { get; set; }
        [Required]
        public string username { get; set; }
        [Required]
        public string adOwner { get; set; }
        [Required]
        public string adName { get; set; }
    }
}
