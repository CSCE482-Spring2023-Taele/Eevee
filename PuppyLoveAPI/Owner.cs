using MySql.Data;
using MySql.Data.MySqlClient;
using MySqlX.XDevAPI;
using System.Collections;
using System.Text.Json;

namespace PuppyLoveAPI
{
    public class Owner
    {
        public int OwnerID { get; set; }
        public string OwnerName { get; set; }
        public string OwnerEmail { get; set; }
        public string InstagramKey { get; set; }
        public int Age { get; set; }
        public string Sex { get; set; }
        public string Location { get; set; }

        public Owner()
        {
            this.OwnerID = -1;
            this.OwnerName = string.Empty;
            this.OwnerEmail = string.Empty;
            this.InstagramKey = String.Empty;
            this.Age = -1;
            this.Sex = String.Empty;
            this.Location = String.Empty;
        }

        public static string GetOwners()
        {
            List<Owner> owners = new List<Owner>();
            DBConnection DB = DBConnection.Instance();

            if (DB.IsConnect())
            {
                string query = "SELECT * from owners;";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                MySqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    int ownerId = Int32.Parse(reader.GetString(0));
                    string ownerName = reader.GetString(1);
                    string ownerEmail = reader.GetString(2);
                    int age = Int32.Parse(reader.GetString(3));
                    string sex = reader.GetString(4);
                    string location = reader.GetString(5);
                    string instaKey = reader.GetString(6);

                    Owner owner = new Owner();
                    owner.OwnerID = ownerId;
                    owner.OwnerName = ownerName;
                    owner.OwnerEmail = ownerEmail;
                    owner.InstagramKey = instaKey;
                    owner.Age = age;
                    owner.Sex = sex;
                    owner.Location = location;

                    owners.Add(owner);
                }
                DB.Close();
            }
            return JsonSerializer.Serialize(owners);
        }

        public static string GetOwnerID(string email)
        {
            DBConnection DB = DBConnection.Instance();
            Owner owner = new Owner();

            if (DB.IsConnect())
            {
                string query = $"SELECT * from owners where email = \'{email}\';";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                MySqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    int ownerId = Int32.Parse(reader.GetString(0));
                    string ownerName = reader.GetString(1);
                    string ownerEmail = reader.GetString(2);
                    int age = Int32.Parse(reader.GetString(3));
                    string sex = reader.GetString(4);
                    string location = reader.GetString(5);
                    string instaKey = reader.GetString(6);

                    owner.OwnerID = ownerId;
                    owner.OwnerName = ownerName;
                    owner.OwnerEmail = ownerEmail;
                    owner.InstagramKey = instaKey;
                    owner.Age = age;
                    owner.Sex = sex;
                    owner.Location = location;
                }
                DB.Close();
            }
            return JsonSerializer.Serialize(owner);
        }
    }
}
