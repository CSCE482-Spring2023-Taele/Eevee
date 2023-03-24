using MySql.Data;
using MySql.Data.MySqlClient;
using MySqlX.XDevAPI;
using System.Collections;
using System.Text.Json;

namespace PuppyLoveAPI
{
    public class Dog
    {
        public int DogID { get; set; }
        public int OwnerID { get; set; }
        public string DogName { get; set; }
        public string Breed { get; set; }
        public int Age { get; set; }
        public string Sex { get; set; }
        public int AgressivenessLevel { get; set; }
        public string AdditionalInfo { get; set; }

        public Dog()
        {
            this.DogID = -1;
            this.OwnerID = -1;
            this.DogName = string.Empty;
            this.Breed = String.Empty;
            this.Age = -1;
            this.Sex = String.Empty;
            this.AgressivenessLevel = -1;
            this.AdditionalInfo = String.Empty;
        }

        public static string GetOwners()
        {
            List<Dog> dogs = new List<Dog>();
            DBConnection DB = DBConnection.Instance();

            if (DB.IsConnect())
            {
                string query = "SELECT * from dogs";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                MySqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    int dogId = Int32.Parse(reader.GetString(0));
                    int ownerId = Int32.Parse(reader.GetString(1));
                    string dogName = reader.GetString(2);
                    string breed = reader.GetString(3);
                    int age = Int32.Parse(reader.GetString(4));
                    string sex = reader.GetString(5);
                    int agressivenessLevel = Int32.Parse(reader.GetString(6));
                    string additionalInfo = reader.GetString(7);

                    Dog dog = new Dog();
                    dog.DogID = dogId;
                    dog.OwnerID = ownerId;
                    dog.DogName = dogName;
                    dog.Breed = breed;
                    dog.Age = age;
                    dog.AgressivenessLevel = agressivenessLevel;
                    dog.AdditionalInfo = additionalInfo;

                    dogs.Add(dog);
                }
                DB.Close();
            }
            return JsonSerializer.Serialize(dogs);
        }
    }
}
