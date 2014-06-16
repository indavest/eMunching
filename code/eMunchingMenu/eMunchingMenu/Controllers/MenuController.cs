using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using eMunchingMenu.Models;
using eMunchingMenu.Repositories;

namespace eMunchingMenu.Controllers
{
    public class MenuController : Controller
    {
        private eMunchingEntities _context = new eMunchingEntities();
        private MenuItemRepository _repo = new MenuItemRepository(); 

        /// <summary>
        /// Gets the Menu
        /// The menu is an abstract data type that we've created in Models. The hierarchy goes like this:
        /// Menu
        ///     MenuCategory1
        ///         MenuItem1
        ///         MenuItem2
        ///     MenuCategory1
        ///         MenuItem3
        ///         MenuItem4
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ActionResult Index(int id, int? categoryId)
        {
            ViewBag.categoryId = categoryId;

            Menu menu = GetMenu(id);

            return View(menu);

            //return Json(new { Result = "OK", Records = retVal, TotalRecordCount = retVal.Count });
        }

        private Menu GetMenu(int id)
        {
            //Declare a new menu
            Menu menu = new Menu();
            menu.RestaurantName = _repo.GetRestaurantName(id);

            //Get all the menu items from the repository and build the abstract menu datatype
            List<MenuItem> MenuItems = _repo.FindAllMenuItems(id).ToList();

            //The restaurant field is causing a circular reference. 
            //So, we need to massage every field except Restaurant field
            List<MenuCategory> menuCategories = new List<MenuCategory>();

            foreach (MenuItem menuItem in MenuItems)
            {
                //massage the images into the images collection
                List<string> images = new List<string>();
                images.Add(menuItem.ItemImage1);
                images.Add(menuItem.ItemImage2);
                images.Add(menuItem.ItemImage3);

                //massage the mealtypes supported into the mealTypeList Collection
                List<MealTypesSupported> mealTypeList = new List<MealTypesSupported>();
                var mealTypeStrings = menuItem.MealType.Split(',').ToList();
                foreach (string mealType in mealTypeStrings)
                {
                    if (null != mealType && String.Empty != mealType && "" != mealType)
                    {
                        mealTypeList.Add((MealTypesSupported)int.Parse(mealType));
                    }
                }

                //massage the IsVeg value to a boolean
                bool flagIsVeg = true;

                //Check for NULL or 0, assign boolean to false, thereby indicating that the dish is Non-Veg
                if (!menuItem.Veg.HasValue || menuItem.Veg == 0)
                {
                    flagIsVeg = false;
                }

                _MenuItem _menuItem = (new _MenuItem
                {
                    Id = menuItem.MenuItemID,
                    Name = menuItem.Item,
                    Description = menuItem.ItemDesc,
                    Price = float.Parse(menuItem.ItemPriceA.ToString().Trim()),
                    Images = images,
                    Thumbnail = menuItem.ItemImage1,
                    MealTypes = mealTypeList,
                    IsVeg = flagIsVeg
                });

                //if category exists, add item to existing category
                MenuCategory existingCategory = menuCategories.Find(i => i.CategoryName == menuItem.MenuItemGroup.MenuItemGroup1);

                //if found, then add the menu items to this category
                if (null != existingCategory)
                {
                    existingCategory.MenuItems.Add(_menuItem);
                }
                else //if not found, add the new category
                {
                    List<_MenuItem> menuItems = new List<_MenuItem>();
                    menuItems.Add(_menuItem);

                    menuCategories.Add(new MenuCategory
                    {
                        CategoryId = menuItem.MenuItemGroup.MenuItemGroupID,
                        CategoryName = menuItem.MenuItemGroup.MenuItemGroup1,
                        MenuItems = menuItems
                    });

                }
            }

            //add all the categories to the menu
            menu.MenuCategories = menuCategories;
            return menu;
        }

        public ActionResult SlideShow(int id, int? categoryId)
        {
            ViewBag.categoryId = categoryId;

            Menu menu = GetMenu(id);

            return View(menu);
        }

        //
        // GET: /MenuItem/Details/5

        public ActionResult Details(int id)
        {
            return View();
        }
    }
}
