using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using eMunchingMenu.Models;

namespace eMunchingMenu.Repositories
{
    public class DealRepository
    {
        //handle to the database entities
        private eMunchingEntities entities = new eMunchingEntities();

        //Query Methods

        /// <summary>
        /// Get the restaurant name
        /// </summary>
        /// <param name="RestaurantId"></param>
        /// <returns></returns>
        public string GetRestaurantName(int RestaurantId)
        {
            IQueryable<string> restaurantNames = from restaurant in entities.Restaurants
                                    where restaurant.id == RestaurantId
                                    select restaurant.name;
            
            return restaurantNames.ToList()[0];
        }

        /// <summary>
        /// Gets all the MenuItems for all restuarants.
        /// </summary>
        /// <returns></returns>
        public IQueryable<MenuItem> FindAllMenuItems()
        {
            return entities.MenuItems;
        }

        /// <summary>
        /// Gets all the MenuItems for a particular restaurant
        /// </summary>
        /// <param name="RestaurantId"></param>
        /// <returns></returns>
        public IQueryable<MenuItem> FindAllMenuItems(int RestaurantId)
        {
            return from menuItem in entities.MenuItems
                   where menuItem.Restaurant == RestaurantId
                   orderby menuItem.GroupCategory
                   select menuItem;
        }

        public IQueryable<MenuItemGroupsCategory> GetMenu(int restaurantId)
        {
            var modelMenuCategories = entities.MenuItemGroupsCategories;
            return modelMenuCategories;
        }

        /// <summary>
        /// Gets a MenuItem by it's id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public MenuItem GetMenuItem(int id)
        {
            return entities.MenuItems.FirstOrDefault(mI => mI.Restaurant == id);
        }
    }
}