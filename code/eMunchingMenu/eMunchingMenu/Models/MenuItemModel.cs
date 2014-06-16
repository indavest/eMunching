using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace eMunchingMenu.Models
{
    public enum MealTypesSupported { Breakfast = 0, Brunch, Lunch , Tea , Dinner , Supper };

    public class Menu
    {
        #region Private fields
        private string restaurantName;
        private List<MenuCategory> menuCategories;
        #endregion Private fields

        #region Public Properties
        public string RestaurantName
        {
            get { return restaurantName; }
            set { restaurantName = value; }
        }

        public List<MenuCategory> MenuCategories
        {
            get { return menuCategories; }
            set { menuCategories = value; }
        }
        #endregion Public Properties
    }

    /// <summary>
    /// This is a Category of food items
    /// eg: Starters, Main Course, Poultry, Seafood, Desserts etc
    /// </summary>
    public class MenuCategory
    {
        #region Private fields
        private int categoryId;
        private string categoryName;
        private List<_MenuItem> menuItems;
        
        #endregion Private fields

        #region Public Properties

        /// <summary>
        /// Category Id
        /// </summary>
        public int CategoryId
        {
            get { return categoryId; }
            set { categoryId = value; }
        }

        /// <summary>
        /// Category Name
        /// </summary>
        public string CategoryName
        {
            get { return categoryName; }
            set { categoryName = value; }
        }

        /// <summary>
        /// Menu Item List
        /// </summary>
        public List<_MenuItem> MenuItems
        {
            get { return menuItems; }
            set { menuItems = value; }
        }
        
        #endregion Public Properties
    }

    /// <summary>
    /// This object represents a Menu Item
    /// eg: Veggie Spring Roll, Chicken Tikka, Chocolate Ice Cream etc
    /// </summary>
    public class _MenuItem
    {
        #region Private fields

        private int id;
        private string name, description, thumbnail;
        private float price;
        private List<string> images;
        private List<MealTypesSupported> mealTypes;
        private bool isVeg;
        
        #endregion Private fields

        #region Public Properties
        
        public int Id
        {
            get { return id; }
            set { id = value; }
        }


        public string Name
        {
            get { return name; }
            set { name = value; }
        }
        

        public string Description
        {
            get { return description; }
            set { description = value; }
        }


        public float Price
        {
            get { return price; }
            set { price = value; }
        }
        
        public List<string> Images
        {
            get { return images; }
            set { images = value; }
        }


        public string Thumbnail
        {
            get { return thumbnail; }
            set { thumbnail = value; }
        }

        public List<MealTypesSupported> MealTypes
        {
            get { return mealTypes; }
            set { mealTypes = value; }
        }

        public bool IsVeg
        {
            get { return isVeg; }
            set { isVeg = value; }
        }

        #endregion Public Properties
    }
}