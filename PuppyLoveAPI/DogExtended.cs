namespace PuppyLoveAPI
{
    public class DogExtended
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
        public string Email { get; set; }
        public DogExtended()
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
            this.Email = String.Empty;
        }
    }
}