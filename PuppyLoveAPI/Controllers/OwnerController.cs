using Microsoft.AspNetCore.Mvc;

namespace PuppyLoveAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class OwnerController : ControllerBase
    {
        private readonly ILogger<OwnerController> _logger;

        public OwnerController(ILogger<OwnerController> logger)
        {
            _logger = logger;
        }

        [HttpGet(Name = "GetOwner")]
        public IEnumerable<Owner> Get()
        {
            return Enumerable.Range(1, 5).Select(index => new Owner
            {
                OwnerName = Owner.GetOwners()
            })
           .ToArray();
        }
    }
}