using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace ChatBackend.Models
{
    public class Comment
    {
        [Key]
        public Guid Id { get; set; }
        [Required]
        public int idOglasa { get; set;}
        [Required]
        public string nazivOglasa { get; set; }
        [Required]
        public string korisnik { get; set; }
        [Required]
        public string tekst { get; set; }
    }
}
