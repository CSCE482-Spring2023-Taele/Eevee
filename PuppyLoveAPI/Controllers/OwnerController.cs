using Microsoft.AspNetCore.Mvc;
using System.Net.Mime;

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

        [HttpGet("{email}, {id}", Name = "GetOwnerEmail")]
        public string GetEmail(string email, int id)
        {
            return Owner.GetOwnerEmail(email);
        }

        [HttpGet("{id}", Name = "GetOwnerID")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public ActionResult<Owner> GetById_ActionResultOfT(int id)
        {
            Owner owner = Owner.GetOwnerID(id);
            return owner == null ? NotFound() : owner;
        }

        [HttpPost(Name = "PostOwner")]
        [Consumes(MediaTypeNames.Application.Json)]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public ActionResult<Owner> Create(Owner owner)
        {
            
            if (!Owner.AddOwner(owner))
            {
                return BadRequest();
            }
            if (!Owner.GetNewID(owner))
            {
                // Owner was not created
                return BadRequest();
            }

            return CreatedAtAction(nameof(GetById_ActionResultOfT), new { id = owner.OwnerID }, owner);
        }
    }
}