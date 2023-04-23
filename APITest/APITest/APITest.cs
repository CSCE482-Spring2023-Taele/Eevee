using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Text.Json;

namespace PuppyLoveAPI
{
    [TestClass]
    public class APITest
    {
        [TestMethod]
        public void TestOwnerList()
        {
            string owner = "[{\"OwnerID\":1,\"OwnerName\":\"Aaron Sanchez\",\"OwnerEmail\":\"aaronsanchez01@tamu.edu\",\"Age\":21,\"MinAge\":18,\"MaxAge\":92,\"Sex\":\"male\",\"SexPreference\":\"everyone\",\"Location\":\"30.5925956,-96.3332524\",\"MaxDistance\":40}";
            string actual = Owner.GetOwners();
            //StringAssert.Contains(owner, actual);
            string sub = actual.Substring(0, owner.Length);

            Assert.AreEqual(owner, sub);
        }

        [TestMethod]
        public void TestOwnerByEmail()
        {
            string owner = "{\"OwnerID\":1,\"OwnerName\":\"Aaron Sanchez\",\"OwnerEmail\":\"aaronsanchez01@tamu.edu\",\"Age\":21,\"MinAge\":18,\"MaxAge\":92,\"Sex\":\"male\",\"SexPreference\":\"everyone\",\"Location\":\"30.5925956,-96.3332524\",\"MaxDistance\":40}";
            string actual = Owner.GetOwnerEmail("aaronsanchez01@tamu.edu");

            Assert.AreEqual(owner, actual);
        }

        [TestMethod]
        public void TestDogById()
        {
            string dog = "{\"DogID\":1,\"OwnerID\":1,\"DogName\":\"Emmie\",\"Breed\":\"Lab\",\"Weight\":91,\"Age\":\"8\\u002B Archaic\",\"Sex\":\"female\",\"ActivityLevel\":1,\"VaccinationStatus\":true,\"FixedStatus\":true,\"BreedPreference\":\"none\",\"AdditionalInfo\":\"She is a good old gal.\"}";
            string actual = JsonSerializer.Serialize(Dog.GetDogId(1));

            Assert.AreEqual(dog, actual);
        }

        [TestMethod]
        public void TestDogList()
        {
            string dog = "[{\"DogID\":1,\"OwnerID\":1,\"DogName\":\"Emmie\",\"Breed\":\"Lab\",\"Weight\":91,\"Age\":\"8\\u002B Archaic\",\"Sex\":\"female\",\"ActivityLevel\":1,\"VaccinationStatus\":true,\"FixedStatus\":true,\"BreedPreference\":\"none\",\"AdditionalInfo\":\"She is a good old gal.\"}";
            string actual = Dog.GetDogs();
            string sub = actual.Substring(0, dog.Length);

            Assert.AreEqual(dog, sub);
        }

        [TestMethod]
        public void TestMatchingList()
        {
            string matchInfo = "{\"Age\":21,\"MinAge\":18,\"MaxAge\":92,\"Sex\":\"male\",\"SexPreference\":\"everyone\",\"Location\":\"30.5925956,-96.3332524\",\"MaxDistance\":40,\"ActivityLevel\":1,\"Weight\":91,\"Breed\":\"Lab\",\"BreedPreference\":\"none\"}";
            string actual = MatchingInfo.GetMatchingInfo("aaronsanchez01@tamu.edu");

            Assert.AreEqual(matchInfo, actual);
        }

        [TestMethod]
        public void TestSwipeId()
        {
            string expected = "{\"OutcomeID\":1,\"CurrDogID\":1,\"ReviewedDogID\":2,\"Timestamp\":\"Sun, 23 Apr 2023 23:31:11 GMT\",\"Outcome\":1}";
            string actual = JsonSerializer.Serialize(Swipe.GetID(1));

            Assert.AreEqual(expected, actual);
        }
    }
}
