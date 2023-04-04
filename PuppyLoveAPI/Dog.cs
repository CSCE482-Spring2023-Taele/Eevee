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
        public string Age { get; set; }
        public string Sex { get; set; }
        public int ActivityLevel { get; set; }
        public bool VaccinationStatus { get; set; }
        public bool FixedStatus { get; set; }
        public string BreedPreference { get; set; }
        public string AdditionalInfo { get; set; }

        public Dog()
        {
            this.DogID = -1;
            this.OwnerID = -1;
            this.DogName = string.Empty;
            this.Breed = String.Empty;
            this.Age = string.Empty;
            this.Sex = String.Empty;
            this.ActivityLevel = -1;
            this.VaccinationStatus = false;
            this.FixedStatus = false;
            this.BreedPreference = string.Empty;
            this.AdditionalInfo = String.Empty;
        }

        public static string GetDogs()
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
                    string age = reader.GetString(4);
                    string sex = reader.GetString(5);
                    int activityLevel = Int32.Parse(reader.GetString(6));
                    bool vaccinationStatus = bool.Parse(reader.GetString(7));
                    bool fixedStatus = bool.Parse(reader.GetString(8));
                    string breedPreference = reader.GetString(9);
                    string additionalInfo = reader.GetString(10);

                    Dog dog = new Dog();
                    dog.DogID = dogId;
                    dog.OwnerID = ownerId;
                    dog.DogName = dogName;
                    dog.Breed = breed;
                    dog.Age = age;
                    dog.Sex = sex;
                    dog.ActivityLevel = activityLevel;
                    dog.VaccinationStatus = vaccinationStatus;
                    dog.FixedStatus = fixedStatus;
                    dog.BreedPreference = breedPreference;
                    dog.AdditionalInfo = additionalInfo;

                    dogs.Add(dog);
                }
                DB.Close();
            }
            return JsonSerializer.Serialize(dogs);
        }
    }
}
