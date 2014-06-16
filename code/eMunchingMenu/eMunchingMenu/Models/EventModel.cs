using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using eMunchingMenu.Repositories;

namespace eMunchingMenu.Models
{
    public class Event
    {
        #region private fields
        private int eventId;
        private int restaurantId;
        private int location;
        private string name;
        private string description;
        private DateTime date;
        private string time;
        private bool isActive;
        #endregion private fields

        #region public properties
        public int EventId
        {
            get { return eventId; }
            set { eventId = value; }
        }

        public int RestaurantId
        {
            get { return restaurantId; }
            set { restaurantId = value; }
        }

        public int Location
        {
            get { return location; }
            set { location = value; }
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

        public DateTime Date
        {
            get { return date; }
            set { date = value; }
        }

        public string Time
        {
            get { return time; }
            set { time = value; }
        }

        public bool IsActive
        {
            get { return isActive; }
            set { isActive = value; }
        }
        #endregion public properties
    }

    public class EventModel
    {
        private eMunchingEntities _context = new eMunchingEntities();
        private EventRepository _repo = new EventRepository();

        private int restaurantId;
        private List<Event> events;

        /// <summary>
        /// Public list of all Events
        /// </summary>
        public List<Event> Events
        {
            get 
            {
                var dbEvents = _repo.GetEventByRestaurantId(restaurantId).ToList();

                foreach (RestaurantEvent dbevent in dbEvents)
                {
                    Event e = new Event();
                    e.Date = DateTime.Parse(dbevent.Date);
                    e.Description = dbevent.Description;
                    e.EventId = dbevent.EventID;
                    if (dbevent.Active == 0)
                    {
                        e.IsActive = false;
                    }
                    else
                    {
                        e.IsActive = true;
                    }
                    e.Location = dbevent.Loca;
                    e.Name = dbevent.Name;
                    e.RestaurantId = restaurantId;
                    e.Time = dbevent.Time;

                    events.Add(e);
                }
                return events; 
            }
        }

        /// <summary>
        /// Constructor that takes a restaurantId
        /// </summary>
        /// <param name="restaurantId"></param>
        public EventModel(int restaurantId)
        {
            //set the restaurantId
            this.restaurantId = restaurantId;
            //initialize the list of events
            this.events = new List<Event>();
        }
    }
}