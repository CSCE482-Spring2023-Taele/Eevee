using MySql.Data.MySqlClient;
using Mysqlx.Crud;
using System.Runtime.CompilerServices;

namespace PuppyLoveAPI
{
    public class Swipe
    {
        public int OutcomeID { get; set; }
        public int CurrDogID { get; set; }
        public int ReviewedDogID { get; set; }
        public string Timestamp { get; set; }
        public short Outcome { get; set; }

        public Swipe()
        {
            this.OutcomeID = -1;
            this.CurrDogID = -1;
            this.ReviewedDogID = -1;
            this.Timestamp = DateTime.Now.ToString();
            this.Outcome = 0;
        }

        public static Swipe GetID(int id)
        {
            Swipe swipe = new Swipe();
            DBConnection DB = DBConnection.Instance();

            if (DB.IsConnect())
            {
                if (id == -1) // Don't want to query the db in the case the id is bad
                {
                    DB.Close();
                    return swipe;
                }

                string query = $"SELECT * from owners where owner_id = {id};";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                MySqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    try
                    {
                        swipe.OutcomeID = Int32.Parse(reader.GetString(0));
                        swipe.CurrDogID = Int32.Parse(reader.GetString(1));
                        swipe.ReviewedDogID = Int32.Parse(reader.GetString(2));
                        swipe.Timestamp = reader.GetString(3);
                        swipe.Outcome = short.Parse(reader.GetString(4)); // This might cause me errors
                    }
                    catch (Exception e)
                    {
                        DB.Close();
                        return swipe;
                    }
                }
                DB.Close();
            }

            return swipe;
        }

        public static bool SendSwipe(Swipe swipe)
        {
            bool sent = false;

            DBConnection DB = DBConnection.Instance();

            if (DB.IsConnect())
            {
                // referenced from https://www.c-sharpcorner.com/UploadFile/9582c9/insert-update-delete-display-data-in-mysql-using-C-Sharp/
                string query = $"insert into swipe_outcomes values(NULL, {swipe.CurrDogID}, {swipe.ReviewedDogID}, \'{swipe.Timestamp}\', {swipe.Outcome});";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                try
                {
                    MySqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        // dog.DogID = Int32.Parse(reader.GetString(0));
                        swipe.CurrDogID = reader.GetInt32(0);
                    }
                    reader.Close();
                }
                catch (Exception e)
                {
                    DB.Close();
                    return sent;
                }

                bool isMatch = false;
                if (swipe.Outcome == 1)
                {
                    string matchQuery = $"select outcome from swipe_outcomes where current_dog_id = {swipe.ReviewedDogID} and reviewed_dog_id = {swipe.CurrDogID};";
                    MySqlCommand matchCmd = new MySqlCommand(matchQuery, DB.Connection);
                    try
                    {
                        MySqlDataReader reader = matchCmd.ExecuteReader();
                        if (reader.Read())
                        {
                            // tells us there is a match
                            short i = reader.GetInt16(0);
                            if (i == 1)
                            {
                                isMatch = true;
                            }
                        }
                        reader.Close();
                    }
                    catch (Exception e)
                    {
                        DB.Close();
                        return sent;
                    }
                }

                if (isMatch) // This is going to automatically update the users matches based off of the swipe outcomes
                {
                    string matchQuery = $"insert into matches values(NULL, {swipe.CurrDogID}, {swipe.ReviewedDogID});";
                    MySqlCommand matchCmd = new MySqlCommand(matchQuery, DB.Connection);
                    try
                    {
                        MySqlDataReader reader = matchCmd.ExecuteReader();
                        reader.Close();
                    }
                    catch (Exception e)
                    {
                        DB.Close();
                        return sent;
                    }
                }

                DB.Close();
            }

            sent = true;
            return sent;
        }
    }
}
