using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MiniApp.Models
{
    public class User
    {
        public long Id { get; set; }
        public string ime { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
    }
}
