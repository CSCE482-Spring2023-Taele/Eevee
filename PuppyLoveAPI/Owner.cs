using MySql.Data;
using MySql.Data.MySqlClient;
using MySqlX.XDevAPI;

namespace PuppyLoveAPI
{
    public class Owner
    {
        public int OwnerID { get; set; }
        public string OwnerName { get; set; }
        public string InstagramKey { get; set; }
        public int Age { get; set; }
        public string Sex { get; set; }
        public string Location { get; set; }

        public static string GetOwners()
        {
            DBConnection DB = DBConnection.Instance();
            DB.Server = @"puppy-love.mysql.database.azure.com";
            DB.DatabaseName = @"puppy_love";
            DB.UserName = @"";
            DB.Password = @"";

            string someStringFromColumnZero = "";

            if (DB.IsConnect())
            {
                string query = "SELECT * from owners";
                MySqlCommand cmd = new MySqlCommand(query, DB.Connection);
                var reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    someStringFromColumnZero = reader.GetString(0);
                    string someStringFromColumnOne = reader.GetString(1);
                    Console.WriteLine(someStringFromColumnZero + "," + someStringFromColumnOne);
                }
                DB.Close();
            }

            return someStringFromColumnZero;
        }
    }
}
