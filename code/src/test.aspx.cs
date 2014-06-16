using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JdSoft;
using JdSoft.Apple.Apns.Notifications;
using System.Collections;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using eMunching_Loyalty_DataManager;

public partial class test : System.Web.UI.Page
{
    static Hashtable connectionObject = Helper.getDBNamesAndConnectionStrings();
    protected void Page_Load(object sender, EventArgs e)
    {
        //Response.Write(Helper.checkEmailEnabledByRestByAction(74,1));
        //sendNotifications();
        //if (Helper.checkNotificationsEnabledByRestByAction(36, 2)) 
        //{
        //    Response.Write("Game is ON");
        //}
        LoyaltyHelper.uploadUniqueCodesToServer();
        //LoyaltyHelper.uploadCouponCodesToServer();
        
        //string filepath = StringConstants.RESTAURANT_PAYLOAD_PATH;
        //DirectoryInfo dir = new DirectoryInfo(filepath);
        //foreach (FileInfo file in dir.GetFiles())
        //{
        //    Response.Write(file.Name);
        //}
        //LoyaltyHelper.WriteToTextFile(";","test.csv");
        //sendNotifications();
        //LoyaltyHelper.uploadToitUniquecodes();
		DateTime thisDate = DateTime.Now;
		//Response.Write(thisDate);
        //Response.Write(thisDate.ToString("yyyyMMdd"));
        Response.Write(DateTime.Today.AddDays(-1).ToString("yyyyMMdd"));
        //Repository loyaltyRepository = new Repository();
        //loyaltyRepository.GenerateCouponCodes();
    }

    protected void sendNotifications()
    {
        string p12FileName = HttpContext.Current.Request.PhysicalApplicationPath + "certificates/apn_developer_toit_identity.p12"; // change this to reflect your own certificate
        Response.Write(p12FileName);
        string p12Password = "emunching"; // change this    
        bool sandBox = true;
        string deviceToken = "a15fb134ea8459c8c4eb6bb047732e6dca78cf3aea09626e806b60ab16ab3c27";
        int badge = 11;
        string ActionType = "Event";
        int numConnections = 1; // you can change the number of connections here
        try
        {
            var notificationService = new NotificationService(sandBox, p12FileName, p12Password, numConnections);
            //List<string> deviceTokens = NotificationHelper.getDeviceTokenByRestaurant(RestId);
            //string connectionString = (string)connectionObject["connectionStringApp"];
            var notification = new Notification(deviceToken);
            notification.Payload.Badge = badge;
            notification.Payload.AddCustom("ActionType", ActionType);
            //Utilities.Log("Payload is: " + notification.Payload.ToString(), true);
            if (notificationService.QueueNotification(notification))
            {
                Response.Write("Working");
                //markNotificationSentToAPNS(deviceToken, notificationIds);
            }
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }
        System.Threading.Thread.Sleep(1500);
    }

    public void updateRestaurants()
    {
        Hashtable loyaltyConnectionObj = Helper.getDBNameAndConnectionStringForLoyalty();
        string loyaltyConnectionString = (string)loyaltyConnectionObj["connectionStringApp"];
        string connectionString = (string)connectionObject["connectionStringApp"];
        SqlConnection con = null;
        SqlCommand sql = null;
        SqlDataReader dataReader = null;
        string query = "";
        con = new SqlConnection(connectionString);
        con.Open();
        sql = new SqlCommand("SELECT * FROM Restaurant", con);
        dataReader = sql.ExecuteReader();
        query = "INSERT INTO Restaurants (ID, RestaurantName) values";
        while (dataReader.Read())
        {
            string name = dataReader["name"].ToString();
            name = name.Replace("'", @"\'");
            query += "(" + dataReader["id"] + ",@name),";

        }
        con.Close();
        query = query.TrimEnd(',');
        Response.Write(query);
        con = new SqlConnection(loyaltyConnectionString);
        con.Open();
        sql = new SqlCommand(query, con);
        Response.Write(sql.ExecuteNonQuery());
        con.Close();

    }
}