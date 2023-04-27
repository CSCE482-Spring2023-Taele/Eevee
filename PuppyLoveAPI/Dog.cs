using MySql.Data;
using MySql.Data.MySqlClient;
using Mysqlx.Crud;
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
        public int Weight { get; set; }
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
            this.Weight = -1;
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
                    int weight = Int32.Parse(reader.GetString(4));
                    string age = reader.GetString(5);
                    string sex = reader.GetString(6);
                    int activityLevel = Int32.Parse(reader.GetString(7));
                    bool vaccinationStatus = bool.Parse(reader.GetString(8));
                    bool fixedStatus = bool.Parse(reader.GetString(9));
                    string breedPreference = reader.GetString(10);
                    string additionalInfo = reader.GetString(11);

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

                    dogs.Add(dog);
                }
                DB.Close();
            }
            return JsonSerializer.Serialize(dogs);
        }

        public static string GetDogByEmail(string email)
        {
            DBConnection DB = DBConnection.Instance();
            Dog dog = new Dog();

            if (DB.IsConnect())
            {
                string query = $"select dogs.dog_id, dogs.owner_id, dogs.name, dogs.breed, dogs.weight, dogs.age, dogs.sex, dogs.activity_level, dogs.vaccination_status, dogs.fixed_status, dogs.breed_preference, dogs.additional_info from dogs inner join owners o on o.owner_id = dogs.owner_id where o.email = \'{email}\';\r\n";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                MySqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    int dogId = Int32.Parse(reader.GetString(0));
                    int ownerId = Int32.Parse(reader.GetString(1));
                    string dogName = reader.GetString(2);
                    string breed = reader.GetString(3);
                    int weight = Int32.Parse(reader.GetString(4));
                    string age = reader.GetString(5);
                    string sex = reader.GetString(6);
                    int activityLevel = Int32.Parse(reader.GetString(7));
                    bool vaccinationStatus = bool.Parse(reader.GetString(8));
                    bool fixedStatus = bool.Parse(reader.GetString(9));
                    string breedPreference = reader.GetString(10);
                    string additionalInfo = reader.GetString(11);

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

                }
                DB.Close();
            }
            return JsonSerializer.Serialize(dog);
        }

        public static Dog GetDogId(int id)
        {
            DBConnection DB = DBConnection.Instance();
            Dog dog = new Dog();

            if (DB.IsConnect())
            {
                string query = $"SELECT * from dogs where dog_id = {id}";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                MySqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    int dogId = Int32.Parse(reader.GetString(0));
                    int ownerId = Int32.Parse(reader.GetString(1));
                    string dogName = reader.GetString(2);
                    string breed = reader.GetString(3);
                    int weight = Int32.Parse(reader.GetString(4));
                    string age = reader.GetString(5);
                    string sex = reader.GetString(6);
                    int activityLevel = Int32.Parse(reader.GetString(7));
                    bool vaccinationStatus = bool.Parse(reader.GetString(8));
                    bool fixedStatus = bool.Parse(reader.GetString(9));
                    string breedPreference = reader.GetString(10);
                    string additionalInfo = reader.GetString(11);

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

                }
                DB.Close();
            }
            return dog;
        }

        public static bool CreateDog(Dog dog)
        {
            DBConnection DB = DBConnection.Instance();

            if (DB.IsConnect())
            {
                // referenced from https://www.c-sharpcorner.com/UploadFile/9582c9/insert-update-delete-display-data-in-mysql-using-C-Sharp/
                string query = $"insert into dogs values(NULL, {dog.OwnerID}, \'{dog.DogName}\', \'{dog.Breed}\', {dog.Weight}, \'{dog.Age}\', \'{dog.Sex}\', {dog.ActivityLevel}, {dog.VaccinationStatus}, {dog.FixedStatus}, \'{dog.BreedPreference}\', \'{dog.AdditionalInfo}\');";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                try
                {
                    MySqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        dog.DogID = Int32.Parse(reader.GetString(0));
                    }
                }
                catch (Exception e)
                {
                    DB.Close();
                    return false;
                }
                DB.Close();
            }
            return true;
        }

        public static bool GetNewDogId(Dog dog)
        {
            DBConnection DB = DBConnection.Instance();

            if (DB.IsConnect())
            {
                // referenced from https://www.c-sharpcorner.com/UploadFile/9582c9/insert-update-delete-display-data-in-mysql-using-C-Sharp/
                string query = $"select dog_id from dogs where owner_id = {dog.OwnerID}";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                try
                {
                    MySqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        dog.DogID = Int32.Parse(reader.GetString(0));
                    }
                }
                catch (Exception e)
                {
                    DB.Close();
                    return false;
                }
                DB.Close();
            }
            return true;
        }

    }
}
