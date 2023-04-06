using Microsoft.AspNetCore.Mvc;
using Mysqlx.Crud;
using System.Net.Mime;

namespace PuppyLoveAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MatchingInfoController : ControllerBase
    {
        private readonly ILogger<MatchingInfoController> _logger;

        public MatchingInfoController(ILogger<MatchingInfoController> logger)
        {
            _logger = logger;
        }

        [HttpGet("{email}", Name = "GetMatchingInfo")]
        public string Get(string email)
        {
            return MatchingInfo.GetMatchingInfo(email);
        }
    }
}