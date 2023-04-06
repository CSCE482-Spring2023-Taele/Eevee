using MySql.Data;
using MySql.Data.MySqlClient;
using MySqlX.XDevAPI;
using System.Collections;
using System.Text.Json;

namespace PuppyLoveAPI
{
    public class MatchingInfo
    {
        public int Age { get; set; }
        public int MinAge { get; set; }
        public int MaxAge { get; set; }
        public string Sex { get; set; }
        public string SexPreference { get; set; }
        public string Location { get; set; }
        public int MaxDistance { get; set; }
        public int ActivityLevel { get; set; }
        public int Weight { get; set; }
        public string Breed { get; set; }
        public string BreedPreference { get; set; }

        public MatchingInfo()
        {
            this.Age = -1;
            this.MinAge = -1;
            this.MaxAge = -1;
            this.Sex = String.Empty;
            this.SexPreference = String.Empty;
            this.Location = String.Empty;
            this.MaxDistance = -1;
            this.ActivityLevel = -1;
            this.Weight = -1;
            this.Breed = String.Empty;
            this.BreedPreference = String.Empty;
        }

        public static string GetMatchingInfo(string email)
        {
            MatchingInfo mi = new MatchingInfo();
            DBConnection DB = DBConnection.Instance();

            if (DB.IsConnect())
            {
                string query = $"select owners.age, owners.min_age, owners.max_age, owners.sex, owners.sex_preference, owners.location, owners.max_distance, dogs.activity_level, dogs.weight, dogs.breed, dogs.breed_preference from owners inner join dogs on owners.owner_id where email = \'{email}\';";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                MySqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    int age = Int32.Parse(reader.GetString(0));
                    int minAge = Int32.Parse(reader.GetString(1));
                    int maxAge = Int32.Parse(reader.GetString(2));
                    string sex = reader.GetString(3);
                    string sexPreference = reader.GetString(4);
                    string location = reader.GetString(5);
                    int maxDistance = Int32.Parse(reader.GetString(6));
                    int activityLevel = Int32.Parse(reader.GetString(7));
                    int weight = Int32.Parse(reader.GetString(8));
                    string breed = reader.GetString(9);
                    string breedPreference = reader.GetString(10);

                    mi.Age = age;
                    mi.MinAge = minAge;
                    mi.MaxAge = maxAge;
                    mi.Sex = sex;
                    mi.SexPreference = sexPreference;
                    mi.Location = location;
                    mi.MaxDistance = maxDistance;
                    mi.ActivityLevel = activityLevel;
                    mi.Weight = weight;
                    mi.Breed = breed;
                    mi.BreedPreference = breedPreference;
                }
                DB.Close();
            }
            return JsonSerializer.Serialize(mi);
        }
    }
}
