using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;
using Mysqlx.Crud;
using System.Net.Mime;
using System.Text.Json;

namespace PuppyLoveAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MessageController : ControllerBase
    {
        private readonly ILogger<MessageController> _logger;

        public MessageController(ILogger<MessageController> logger)
        {
            _logger = logger;
        }

        [HttpGet("{email}", Name = "GetMessageInfo")]
        public string Get(string email)
        {
            List<Tuple<String, String, String>> messageList = new List<Tuple<String, String, String>>();
            DBConnection DB = DBConnection.Instance();

            if (DB.IsConnect())
            {
                string query = $"select o1.email, o2.email, d1.name, d2.name, o1.name, o2.name from matches m inner join dogs d1 on d1.dog_id = m.dog_id_1 inner join owners o1 on o1.owner_id = d1.owner_id inner join dogs d2 on d2.dog_id = m.dog_id_2 inner join owners o2 on o2.owner_id = d2.owner_id where o1.email = \'{email}\' OR o2.email = \'{email}\';";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                MySqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    string e1 = reader.GetString(0);
                    string e2 = reader.GetString(1);
                    string dogName1 = reader.GetString(2);
                    string dogName2 = reader.GetString(3);
                    string ownerName1 = reader.GetString(4);
                    string ownerName2 = reader.GetString(5);

                    if (string.Equals(e1, email))
                    {
                        messageList.Add(new Tuple<String, String, String>(e2, dogName2, ownerName2));
                    }
                    else
                    {
                        messageList.Add(new Tuple<String, String, String>(e1, dogName1, ownerName1));
                    }
                }
                DB.Close();
            }


            return JsonSerializer.Serialize(messageList);
        }
    }
}