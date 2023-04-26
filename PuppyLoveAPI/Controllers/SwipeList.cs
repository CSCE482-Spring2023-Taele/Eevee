using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;
using Mysqlx.Crud;
using System.Net.Mime;
using System.Text.Json;

namespace PuppyLoveAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class SwipeListController : ControllerBase
    {
        private readonly ILogger<SwipeListController> _logger;

        public SwipeListController(ILogger<SwipeListController> logger)
        {
            _logger = logger;
        }

        [HttpGet("{email}", Name = "GetListSwipes")]
        public string GetListSwipes(string email)
        {
            int id = -1;
            List<int> swipedIds = new List<int>();
            DBConnection DB = DBConnection.Instance();

            if (DB.IsConnect())
            {
                string query = $"select d.dog_id from dogs d inner join owners o on o.owner_id = d.owner_id where o.email = \'{email}\';";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                MySqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    try
                    {
                        id = Int32.Parse(reader.GetString(0));
                    }
                    catch (Exception e)
                    {
                        DB.Close();
                        return JsonSerializer.Serialize(swipedIds);
                    }
                }
                reader.Close();

                string matchQuery = $"select s.current_dog_id, s.reviewed_dog_id from swipe_outcomes s inner join dogs d1 on d1.dog_id = s.current_dog_id inner join owners o1 on o1.owner_id = d1.owner_id inner join dogs d2 on d2.dog_id = s.reviewed_dog_id inner join owners o2 on o2.owner_id = d2.owner_id where o1.email = \'{email}\' OR o2.email = \'{email}\'; ";
                MySqlCommand matchCmd = new MySqlCommand(matchQuery, DB.Connection);
                MySqlDataReader matchReader = matchCmd.ExecuteReader();
                while (matchReader.Read())
                {
                    try
                    {
                        int id_1 = Int32.Parse(matchReader.GetString(0));
                        int id_2 = Int32.Parse(matchReader.GetString(1));

                        if (id_1 == id && !swipedIds.Contains(id_2))
                        {
                            swipedIds.Add(id_2); // only want the ones i have swiped on
                        }
                    }
                    catch (Exception e)
                    {
                        DB.Close();
                        return JsonSerializer.Serialize(swipedIds);
                    }
                }
                matchReader.Close();

                string swipeQuery = $"select m.dog_id_1, m.dog_id_2 from matches m inner join dogs d1 on d1.dog_id = m.dog_id_1 inner join owners o1 on o1.owner_id = d1.owner_id inner join dogs d2 on d2.dog_id = m.dog_id_2 inner join owners o2 on o2.owner_id = d2.owner_id where o1.email = \'{email}\' OR o2.email = \'{email}\'; ";
                MySqlCommand swipeCmd = new MySqlCommand(swipeQuery, DB.Connection);
                MySqlDataReader swipeReader = swipeCmd.ExecuteReader();
                while (swipeReader.Read())
                {
                    try
                    {
                        int id_1 = Int32.Parse(matchReader.GetString(0));
                        int id_2 = Int32.Parse(matchReader.GetString(1));

                        if (id_1 == id && !swipedIds.Contains(id_2))
                        {
                            swipedIds.Add(id_2);
                        }
                        else if (id_2 == id && !swipedIds.Contains(id_1))
                        {
                            swipedIds.Add(id_1);
                        }
                    }
                    catch (Exception e)
                    {
                        DB.Close();
                        return JsonSerializer.Serialize(swipedIds);
                    }
                }
                swipeReader.Close();

                DB.Close();
            }

            return JsonSerializer.Serialize(swipedIds);
        }
    }
}