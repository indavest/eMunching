using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using eMunchingMenu.Models;

namespace eMunchingMenu.Repositories
{
    public class EventRepository
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
        /// Gets all the RestaurantEvent for all restuarants.
        /// </summary>
        /// <returns></returns>
        public IQueryable<RestaurantEvent> FindAllEvents()
        {
            return entities.RestaurantEvents;
        }

        /// <summary>
        /// Gets all the RestaurantEvent for a particular restaurant
        /// </summary>
        /// <param name="RestaurantId"></param>
        /// <returns></returns>
        public IQueryable<RestaurantEvent> GetEventByRestaurantId(int RestaurantId)
        {
            return from rEvent in entities.RestaurantEvents
                   where rEvent.Restaurant == RestaurantId && rEvent.Active == 1
                   orderby rEvent.Date
                   select rEvent;
        }

        /// <summary>
        /// Get an Event by its Id
        /// </summary>
        /// <param name="eventId"></param>
        /// <returns></returns>
        public RestaurantEvent GetEventByEventId(int eventId)
        {
            return entities.RestaurantEvents.FirstOrDefault(e => e.EventID == eventId);
        }
    }
}