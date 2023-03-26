using Microsoft.AspNetCore.Mvc;
using System.Text.Json;

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
        public string Get()
        {
            return Owner.GetOwners();
        }

        [HttpGet("{id}", Name = "GetOwnerID")]
        public string GetID(int id)
        {
            return Owner.GetOwnerID(id);
        }
    }
}