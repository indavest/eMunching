using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using eMunchingMenu.Models;
using eMunchingMenu.Repositories;

namespace eMunchingMenu.Controllers
{
    public class DealsController : Controller
    {
        private eMunchingEntities _context = new eMunchingEntities();
        private DealRepository _repo = new DealRepository();

        //
        // GET: /Deals/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /Deals/Details/5

        public ActionResult Details(int id)
        {
            return View();
        }

    }
}
