using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;
using Mysqlx.Crud;
using System.Net.Mime;
using System.Text.Json;

namespace PuppyLoveAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class DogIdController : ControllerBase
    {
        private readonly ILogger<DogIdController> _logger;

        public DogIdController(ILogger<DogIdController> logger)
        {
            _logger = logger;
        }

        [HttpGet("{id}", Name = "GetDogIdFromOwner")]
        public string Get(int id)
        {
            DBConnection DB = DBConnection.Instance();
            int dogId = -1;

            if (DB.IsConnect())
            {
                string query = $"SELECT dog_id from dogs where owner_id = {id}";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                MySqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    dogId = Int32.Parse(reader.GetString(0));
                    
                }
                DB.Close();
            }
            return JsonSerializer.Serialize(dogId);
        }
    }
}