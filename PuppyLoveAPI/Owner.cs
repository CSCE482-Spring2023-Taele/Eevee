using Microsoft.AspNetCore.Mvc;
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
        public int Age { get; set; }
        public int MinAge { get; set; }
        public int MaxAge { get; set; }
        public string Sex { get; set; }
        public string SexPreference { get; set; }
        public string Location { get; set; }
        public int MaxDistance { get; set; }
        public Owner()
        {
            this.OwnerID = -1;
            this.OwnerName = string.Empty;
            this.OwnerEmail = string.Empty;
            this.Age = -1;
            this.MinAge = 18;
            this.MaxAge = 100;
            this.Sex = String.Empty;
            this.Location = String.Empty;
            this.MaxDistance = 100;
        }

        public static bool AddOwner(Owner owner)
        {
            DBConnection DB = DBConnection.Instance();

            if (DB.IsConnect())
            {
                string query = $"SELECT * from owners where email = \'{owner.OwnerEmail}\';";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                MySqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    DB.Close();
                    return false;
                }

            }

            if (DB.IsConnect())
            {
                // referenced from https://www.c-sharpcorner.com/UploadFile/9582c9/insert-update-delete-display-data-in-mysql-using-C-Sharp/
                string query = $"insert into owners values(NULL, \'{owner.OwnerName}\', \'{owner.OwnerEmail}\', {owner.Age}, {owner.MinAge}, {owner.MaxAge}, \'{owner.Sex}\', \'{owner.Location}\', \'{owner.MaxDistance}\');";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                try
                {
                    MySqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        owner.OwnerID = Int32.Parse(reader.GetString(0));
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
                    // Need to fix for null values
                    int ownerId = Int32.Parse(reader.GetString(0));
                    string ownerName = reader.GetString(1);
                    string ownerEmail = reader.GetString(2);
                    int age = Int32.Parse(reader.GetString(3));
                    int minAge = Int32.Parse(reader.GetString(4));
                    int maxAge = Int32.Parse(reader.GetString(5));
                    string sex = reader.GetString(6);
                    string sexPreference = reader.GetString(7);
                    string location = reader.GetString(8);
                    int maxDistance = Int32.Parse(reader.GetString(9));

                    Owner owner = new Owner();
                    owner.OwnerID = ownerId;
                    owner.OwnerName = ownerName;
                    owner.OwnerEmail = ownerEmail;
                    owner.Age = age;
                    owner.MinAge = minAge;
                    owner.MaxAge = maxAge;
                    owner.Sex = sex;
                    owner.SexPreference = sexPreference;
                    owner.Location = location;
                    owner.MaxDistance = maxDistance;

                    owners.Add(owner);
                }
                DB.Close();
            }
            return JsonSerializer.Serialize(owners);
        }

        public static bool GetNewID(Owner owner)
        {
            DBConnection DB = DBConnection.Instance();

            if (DB.IsConnect())
            {
                string query = $"SELECT owner_id from owners where email = \'{owner.OwnerEmail}\';";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                MySqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    owner.OwnerID = Int32.Parse(reader.GetString(0));
                }
                else
                {
                    DB.Close();
                    return false;
                }

                DB.Close();
            }
            return true;
        }

        public static Owner GetOwnerID(int id)
        {
            DBConnection DB = DBConnection.Instance();
            Owner owner = new Owner();

            if (DB.IsConnect())
            {
                if (id == -1) // Don't want to query the db in the case the id is bad
                {
                    DB.Close();
                    return owner;
                }

                string query = $"SELECT * from owners where id = {id};";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                MySqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    try
                    {
                        int ownerId = Int32.Parse(reader.GetString(0));
                        string ownerName = reader.GetString(1);
                        string ownerEmail = reader.GetString(2);
                        int age = Int32.Parse(reader.GetString(3));
                        int minAge = Int32.Parse(reader.GetString(4));
                        int maxAge = Int32.Parse(reader.GetString(5));
                        string sex = reader.GetString(6);
                        string sexPreference = reader.GetString(7);
                        string location = reader.GetString(8);
                        int maxDistance = Int32.Parse(reader.GetString(9));

                        owner.OwnerID = ownerId;
                        owner.OwnerName = ownerName;
                        owner.OwnerEmail = ownerEmail;
                        owner.Age = age;
                        owner.MinAge = minAge;
                        owner.MaxAge = maxAge;
                        owner.Sex = sex;
                        owner.SexPreference = sexPreference;
                        owner.Location = location;
                        owner.MaxDistance = maxDistance;
                    }
                    catch (Exception e)
                    {
                        DB.Close();
                        return owner;
                    }
                }
                DB.Close();
            }
            return owner;
        }

        public static string GetOwnerEmail(string email)
        {
            DBConnection DB = DBConnection.Instance();
            Owner owner = new Owner();

            if (DB.IsConnect())
            {
                string query = $"SELECT * from owners where email = \'{email}\';";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                MySqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    try
                    {
                        int ownerId = Int32.Parse(reader.GetString(0));
                        string ownerName = reader.GetString(1);
                        string ownerEmail = reader.GetString(2);
                        int age = Int32.Parse(reader.GetString(3));
                        int minAge = Int32.Parse(reader.GetString(4));
                        int maxAge = Int32.Parse(reader.GetString(5));
                        string sex = reader.GetString(6);
                        string sexPreference = reader.GetString(7);
                        string location = reader.GetString(8);
                        int maxDistance = Int32.Parse(reader.GetString(9));

                        owner.OwnerID = ownerId;
                        owner.OwnerName = ownerName;
                        owner.OwnerEmail = ownerEmail;
                        owner.Age = age;
                        owner.MinAge = minAge;
                        owner.MaxAge = maxAge;
                        owner.Sex = sex;
                        owner.SexPreference = sexPreference;
                        owner.Location = location;
                        owner.MaxDistance = maxDistance;
                    }
                    catch (Exception e)
                    {
                        DB.Close();
                        return JsonSerializer.Serialize(owner);
                    }
                }
                DB.Close();
            }
            return JsonSerializer.Serialize(owner);
        }
    }
}
