using Microsoft.AspNetCore.Mvc;
using Mysqlx.Crud;
using System.Net.Mime;

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

        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public ActionResult<Dog> GetById_ActionResultOfT(int id)
        {
            Dog dog = Dog.GetDogId(id);
            return dog == null ? NotFound() : dog;
        }

        [HttpPost(Name = "PostDog")]
        [Consumes(MediaTypeNames.Application.Json)]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public ActionResult<Dog> Create(Dog dog)
        {
            if (!Dog.CreateDog(dog))
            {
                return BadRequest();
            }
            if (!Dog.GetNewDogId(dog))
            {
                // Owner was not created
                return BadRequest();
            }

            return CreatedAtAction(nameof(GetById_ActionResultOfT), new { id = dog.DogID }, dog);
        }
    }
}