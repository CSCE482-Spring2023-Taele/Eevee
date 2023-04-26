using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;
using Mysqlx.Crud;
using System.Net.Mime;
using System.Text.Json;

namespace PuppyLoveAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class SwipeController : ControllerBase
    {
        private readonly ILogger<SwipeController> _logger;

        public SwipeController(ILogger<SwipeController> logger)
        {
            _logger = logger;
        }

        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public ActionResult<Swipe> GetById_ActionResultOfT(int id)
        {
            Swipe swipe = Swipe.GetID(id);
            return swipe == null ? NotFound() : swipe;
        }

        [HttpPost(Name = "PostSwipe")]
        [Consumes(MediaTypeNames.Application.Json)]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public ActionResult<Swipe> Create(Swipe swipe)
        {
            if (!Swipe.SendSwipe(swipe))
            {
                return BadRequest();
            }

            return CreatedAtAction(nameof(GetById_ActionResultOfT), new { id = swipe.OutcomeID }, swipe);
        }
    }
}