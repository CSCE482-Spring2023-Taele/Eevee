using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;
using Mysqlx.Crud;
using System.Net.Mime;
using System.Text.Json;

namespace PuppyLoveAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MatchController : ControllerBase
    {
        private readonly ILogger<MatchController> _logger;

        public MatchController(ILogger<MatchController> logger)
        {
            _logger = logger;
        }

        [HttpGet("{email}", Name = "GetMatchInfo")]
        public string Get(string email)
        {
            List<String> emailList = new List<String>();
            DBConnection DB = DBConnection.Instance();

            if (DB.IsConnect())
            {
                string query = $"select o1.email, o2.email from matches m inner join dogs d1 on d1.dog_id = m.dog_id_1 inner join owners o1 on o1.owner_id = d1.owner_id inner join dogs d2 on d2.dog_id = m.dog_id_2 inner join owners o2 on o2.owner_id = d2.owner_id  where o1.email = \'{email}\' OR o2.email = \'{email}\';";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                MySqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    string e1 = reader.GetString(0);
                    string e2 = reader.GetString(1);

                    if (string.Equals(e1, email))
                    {
                        emailList.Add(e2);
                    }
                    else
                    {
                        emailList.Add(e1);
                    }
                }
                DB.Close();
            }


            return JsonSerializer.Serialize(emailList);
        }
    }
}