using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using eMunchingMenu.Models;
using eMunchingMenu.Repositories;

namespace eMunchingMenu.Controllers
{
    public class EventsController : Controller
    {
        private eMunchingEntities _context = new eMunchingEntities();
        private EventRepository _repo = new EventRepository();

        //
        // GET: /Events/

        public ActionResult Index(int id)
        {
            EventModel em = new EventModel(id);
            return View(em);
        }

        //
        // GET: /Events/Details/5

        public ActionResult Details(int id)
        {
            return View();
        }

    }
}
