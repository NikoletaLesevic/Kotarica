using Microsoft.EntityFrameworkCore;
using MiniApp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MiniApp.Data
{
    public class AppDBContext:DbContext
    {
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlite(@"Data source = Korisnici.db");
        }

        public DbSet<User> Users { get; set; }

    }
}
