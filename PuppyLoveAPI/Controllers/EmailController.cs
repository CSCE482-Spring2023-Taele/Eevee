using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;
using Mysqlx.Crud;
using System.Net.Mime;
using System.Text.Json;

namespace PuppyLoveAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class EmailController : ControllerBase
    {
        private readonly ILogger<EmailController> _logger;

        public EmailController(ILogger<EmailController> logger)
        {
            _logger = logger;
        }

        [HttpGet("{email}", Name = "GetDogByEmailSpecial")]
        public string GetByEmailDog(string email)
        {
            return Dog.GetDogByEmail(email);
        }
    }
}