using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;
using Mysqlx.Crud;
using System.Net;
using System.Net.Mime;
using System.Reflection.Metadata.Ecma335;
using System.Text.Json;

namespace PuppyLoveAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class SwipeListController : ControllerBase
    {
        private readonly ILogger<SwipeListController> _logger;
        private double MatchingScore = 0.0;

        public SwipeListController(ILogger<SwipeListController> logger)
        {
            _logger = logger;
            this.MatchingScore = Double.Parse(Environment.GetEnvironmentVariable("PUPPY_LOVE_MATCHING_SCORE"));
        }

        [HttpGet("{email}", Name = "GetListSwipes")]
        public string GetListSwipes(string email)
        {
            int currDogID = -1;
            List<int> swipedIds = new List<int>();
            Dictionary<int, bool> swiped = new Dictionary<int, bool>();
            List<Dog> returnDogs = new List<Dog>();
            DBConnection DB = DBConnection.Instance();

            if (DB.IsConnect())
            {
                // Get list of dogs that have been swiped on by an owner
                string query = $"select d.dog_id from dogs d inner join owners o on o.owner_id = d.owner_id where o.email = \'{email}\';";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                MySqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    try
                    {
                        currDogID = Int32.Parse(reader.GetString(0));
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

                        if (id_1 == currDogID && !swipedIds.Contains(id_2))
                        {
                            swipedIds.Add(id_2); // only want the ones i have swiped on
                            swiped.Add(id_2, true);
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
                        int id_1 = Int32.Parse(swipeReader.GetString(0));
                        int id_2 = Int32.Parse(swipeReader.GetString(1));

                        if (id_1 == currDogID && !swipedIds.Contains(id_2))
                        {
                            swipedIds.Add(id_2);
                            swiped.Add(id_2, true);
                        }
                        else if (id_2 == currDogID && !swipedIds.Contains(id_1))
                        {
                            swipedIds.Add(id_1);
                            swiped.Add(id_1, true);
                        }
                    }
                    catch (Exception e)
                    {
                        DB.Close();
                        return JsonSerializer.Serialize(swipedIds);
                    }
                }
                swipeReader.Close();


                // return info for dogs that still need to be swiped on
                string dogQuery = $"select * from dogs inner join owners o on o.owner_id = dogs.owner_id where dog_id != {currDogID};";
                List<Tuple<Dog, Owner>> dogs = new List<Tuple<Dog, Owner>>();

                MySqlCommand dogCmd = new MySqlCommand(dogQuery, DB.Connection);
                MySqlDataReader dogReader = dogCmd.ExecuteReader();
                while (dogReader.Read())
                {
                    int dogId = Int32.Parse(dogReader.GetString(0));
                    int ownerId = Int32.Parse(dogReader.GetString(1));
                    string dogName = dogReader.GetString(2);
                    string breed = dogReader.GetString(3);
                    int weight = Int32.Parse(dogReader.GetString(4));
                    string age = dogReader.GetString(5);
                    string sex = dogReader.GetString(6);
                    int activityLevel = Int32.Parse(dogReader.GetString(7));
                    bool vaccinationStatus = bool.Parse(dogReader.GetString(8));
                    bool fixedStatus = bool.Parse(dogReader.GetString(9));
                    string breedPreference = dogReader.GetString(10);
                    string additionalInfo = dogReader.GetString(11);

                    int owner_ownerId = Int32.Parse(dogReader.GetString(12));
                    string ownerName = dogReader.GetString(13);
                    string ownerEmail = dogReader.GetString(14);
                    int owner_age = Int32.Parse(dogReader.GetString(15));
                    int minAge = Int32.Parse(dogReader.GetString(16));
                    int maxAge = Int32.Parse(dogReader.GetString(17));
                    string owner_sex = dogReader.GetString(18);
                    string sexPreference = dogReader.GetString(19);
                    string location = dogReader.GetString(20);
                    int maxDistance = Int32.Parse(dogReader.GetString(21));

                    Owner owner = new Owner();
                    owner.OwnerID = owner_ownerId;
                    owner.OwnerName = ownerName;
                    owner.OwnerEmail = ownerEmail;
                    owner.Age = owner_age;
                    owner.MinAge = minAge;
                    owner.MaxAge = maxAge;
                    owner.Sex = owner_sex;
                    owner.SexPreference = sexPreference;
                    owner.Location = location;
                    owner.MaxDistance = maxDistance;

                    Dog dog = new Dog();
                    dog.DogID = dogId;
                    dog.OwnerID = ownerId;
                    dog.DogName = dogName;
                    dog.Breed = breed;
                    dog.Weight = weight;
                    dog.Age = age;
                    dog.Sex = sex;
                    dog.ActivityLevel = activityLevel;
                    dog.VaccinationStatus = vaccinationStatus;
                    dog.FixedStatus = fixedStatus;
                    dog.BreedPreference = breedPreference;
                    dog.AdditionalInfo = additionalInfo;


                    dogs.Add(new Tuple<Dog, Owner>(dog, owner));
                }
                dogReader.Close();

                List<Tuple<Dog, Owner>> nonRepeatDogs = new List<Tuple<Dog, Owner>>();

                // Get rid of dupes
                for (int i = 0; i < dogs.Count; i++)
                {
                    if (!swiped.ContainsKey(dogs[i].Item1.DogID))
                    {
                        nonRepeatDogs.Add(dogs[i]);
                    }
                }

                // Run matching algo
                for (int i = 0; i < nonRepeatDogs.Count; i++)
                {
                    string html = string.Empty;
                    string url = $"https://puppylovema.azurewebsites.net/api/puppylove?userEmail={email}&matchEmail={nonRepeatDogs[i].Item2.OwnerEmail}";

                    HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                    request.AutomaticDecompression = DecompressionMethods.GZip;

                    using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                    using (Stream stream = response.GetResponseStream())
                    using (StreamReader matchReader2 = new StreamReader(stream))
                    {
                        html = matchReader2.ReadToEnd();
                    }

                    double matchScore = Double.Parse(html);

                    if (matchScore >= this.MatchingScore)
                    {
                        returnDogs.Add(nonRepeatDogs[i].Item1);
                    }
                }

                DB.Close();
            }

            return JsonSerializer.Serialize(returnDogs);
        }
    }
}