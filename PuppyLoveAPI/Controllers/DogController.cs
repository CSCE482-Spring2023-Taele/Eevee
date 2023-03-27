using Microsoft.AspNetCore.Mvc;

namespace PuppyLoveAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class DogController : ControllerBase
    {
        private readonly ILogger<DogController> _logger;

        public DogController(ILogger<DogController> logger)
        {
            _logger = logger;
        }

        [HttpGet(Name = "GetDog")]
        public string Get()
        {
            return Dog.GetDogs();
        }
    }
}