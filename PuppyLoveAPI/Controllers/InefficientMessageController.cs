using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;
using Mysqlx.Crud;
using System.Net.Mime;
using System.Text.Json;

namespace PuppyLoveAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class InefficientMessageController : ControllerBase
    {
        private readonly ILogger<InefficientMessageController> _logger;

        public InefficientMessageController(ILogger<InefficientMessageController> logger)
        {
            _logger = logger;
        }

        [HttpGet("{email}", Name = "GetInefficientMessageInfo")]
        public string Get(string email)
        {
            List<Tuple<String, String, String>> messageList = new List<Tuple<String, String, String>>();
            DBConnection DB = DBConnection.Instance();

            if (DB.IsConnect())
            {
                string query = $"select o.email, d.name, o.name from owners o inner join dogs d on d.owner_id = o.owner_id where o.email = \'{email}\';";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                MySqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    string e1 = reader.GetString(0);
                    string dogName1 = reader.GetString(1);
                    string ownerName1 = reader.GetString(2);

                    messageList.Add(new Tuple<String, String, String>(e1, dogName1, ownerName1));
                    
                }
                DB.Close();
            }


            return JsonSerializer.Serialize(messageList);
        }
    }
}