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
                }
                catch (Exception e)
                {
                    DB.Close();
                    return sent;
                }
                DB.Close();
            }

            return sent;
        }
    }
}
