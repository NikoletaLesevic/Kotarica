using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApplication2.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherForecastController : ControllerBase
    {
        List<string> notes = new List<string>();
        
        [HttpGet]
        public ActionResult<IEnumerable<string>> Get()
        {
            notes.Add("note");
            string[] s = notes.ToArray();
            return s;
        }

        public void Post([FromBody] string note)
        {
            notes.Add(note);
        }

        public void Delete(int id)
        {
            notes.RemoveAt(id);
        }
    }
}
