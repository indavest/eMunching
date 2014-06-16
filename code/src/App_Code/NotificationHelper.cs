using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Sql;
using JdSoft;
using JdSoft.Apple.Apns.Notifications;
using System.Net;
using System.Net.Security;
using System.Text;
using System.IO;

/// <summary>
/// Summary description for NotificationHelper
/// </summary>
public class NotificationHelper
{
    static Hashtable connectionObject = Helper.getDBNamesAndConnectionStrings();
	public NotificationHelper()
	{
		//
		// TODO: Add constructor logic here
		//
	}


    /// <summary>
    /// Takes Restaurant Id and Returns a list of Device Ids Registered for the given Restaurant
    /// </summary>
    /// <param name="RestId"></param>
    /// <returns></returns>
    public static List<string> getDeviceTokenByRestaurant(int RestId)
    {
        string connectionString = (string)connectionObject["connectionStringApp"];
        SqlConnection connection = null;
        SqlCommand sqlCommand = null;
        SqlDataReader dataReader = null;
        connection = new SqlConnection(connectionString);
        List<string> deviceTokenList = new List<string>();
        try
        {
            connection.Open();
            sqlCommand = new SqlCommand("SELECT DISTINCT(DeviceToken) FROM dbo.DeviceToken WHERE Restaurant=" + RestId, connection);
            dataReader = sqlCommand.ExecuteReader();
            if (dataReader.HasRows == false)
            {
            }
            else
            {
                while (dataReader.Read())
                {
                    deviceTokenList.Add(dataReader[0].ToString());
                }

            }

        }
        catch (Exception ex)
        {
            //return ex.Message;
        }
        finally
        {
            connection.Close();
        }

        return deviceTokenList;
    }

    /// <summary>
    /// Registers Notification for Restaurant which will be sent to APNS
    /// </summary>
    /// <param name="RestId"></param>
    public static int registerNotification(int RestId, string ActionType)
    {
        string connectionString = (string)connectionObject["connectionStringApp"];
        SqlConnection connection = null;
        SqlCommand sqlCommand = null;
        connection = new SqlConnection(connectionString);
        string certificateName = "";
        try
        {
            connection.Open();
            sqlCommand = new SqlCommand("SELECT NotificationCertificate FROM AdditionalConfig WHERE Restaurant="+RestId, connection);
            certificateName = (string)sqlCommand.ExecuteScalar();
            connection.Close();
            if (!string.IsNullOrEmpty(certificateName))
            {
                sendNotificationToAPNS(RestId, ActionType, certificateName);
            }
            
        }
        catch (Exception ex)
        {
            return 0;
        }

        return 1;
    }

    /// <summary>
    /// Sends registered notifications to APNS
    /// </summary>
    public static void sendNotificationToAPNS(int RestId, string ActionType, string certificateName)
    {
        string p12FileName = HttpContext.Current.Request.PhysicalApplicationPath + "certificates/"+certificateName; // change this to reflect your own certificate
        string p12Password = "emunching"; // change this
        bool sandBox = true;
        int numConnections = 1; // you can change the number of connections here
        var notificationService = new NotificationService(sandBox, p12FileName, p12Password, numConnections);
        List<string> deviceTokens = NotificationHelper.getDeviceTokenByRestaurant(RestId);
        string connectionString = (string)connectionObject["connectionStringApp"];
        SqlConnection connection = null;
        SqlCommand sqlCommand = null;
        SqlDataReader dataReader = null;
        string sql = "";
        int DEVICE_TOKEN_STRING_SIZE = 64;
        connection = new SqlConnection(connectionString);
        try
        {
            foreach (string deviceToken in deviceTokens)
            {
                connection.Open();
                sql = "SELECT ";
                if (Helper.checkNotificationsEnabledByRestByAction(RestId, 1))
                {
                    sql += "(SELECT COUNT(*) FROM RestaurantEvents WHERE Restaurant=" + RestId + " AND Active=1 AND EventID NOT IN (SELECT EventID FROM RestaurantEventsVisited WHERE Restaurant=" + RestId + " AND DeviceToken='" + deviceToken + "')) + ";
                }
                if (Helper.checkNotificationsEnabledByRestByAction(RestId, 2))
                {
                    sql += "(SELECT COUNT(*) FROM Deals WHERE Restaurant=" + RestId + " AND active=1 AND id NOT IN (SELECT DealID FROM RestaurantDealsVisited WHERE Restaurant=" + RestId + " AND DeviceToken='" + deviceToken + "')) + ";
                }
                if (ServiceHelper.checkNotificationsEnabledByRestByAction(RestId, 4))
                {
                    sql += "(SELECT Count FROM (";
                    sql += "SELECT CASE WHEN EXISTS ( SELECT * FROM LoyaltyNotifications WHERE Restaurant="+RestId+" AND DeviceToken = '" + deviceToken + "')";
                    sql += " THEN (SELECT SUM(Count) FROM LoyaltyNotifications WHERE Restaurant="+RestId+" AND DeviceToken = '"+deviceToken+"')";
                    sql += " ELSE (SELECT 0)";
                    sql += " END AS Count) tabel1) +";
                }
                sql += " 0 as notificationCount";
                sqlCommand = new SqlCommand(sql, connection);
                dataReader = sqlCommand.ExecuteReader();
                List<int> notificationIds = new List<int>();
                int badge = 0;
                while (dataReader.Read())
                {
                    //notificationIds.Add((int)dataReader["id"]);
                    badge = (int)dataReader["notificationCount"];
                }
                if (badge > 0)
                {
                    if (!string.IsNullOrEmpty(deviceToken) && deviceToken.Length != DEVICE_TOKEN_STRING_SIZE)
                    {
                        connection.Close();
                        continue;
                    }
                    var notification = new Notification(deviceToken);
                    notification.Payload.Badge = badge;
                    notification.Payload.AddCustom("ActionType", ActionType);
                    //Utilities.Log("Payload is: " + notification.Payload.ToString(), true);
                    if (notificationService.QueueNotification(notification))
                    {
                        //markNotificationSentToAPNS(RestId, deviceToken, badge, ActionType);
                    }
                    System.Threading.Thread.Sleep(1500);
                    connection.Close();
                }
            }
            
        }
        catch (Exception ex)
        {

        }
        finally
        {
            connection.Close();
        }

        //Utilities.Log("Service Failed: " + token.Token, true);
        // This ensures any queued notifications get sent befor the connections are closed
        //System.Threading.Thread.Sleep(500);
        notificationService.Close();
        notificationService.Dispose();
        //return notificationSent;
    }

    /// <summary>
    /// Removes notification from notification table on success of sendNotificationToAPNS
    /// </summary>
    /// <param name="RestId"></param>
    /// <param name="notificationIds"></param>
    public static int markNotificationSentToAPNS(int restId, string deviceToken, int notificationCount, string actionType)
    {
        string connectionString = (string)connectionObject["connectionStringApp"];
        SqlConnection connection = null;
        SqlCommand sqlCommand = null;
        string sqlQuery = "";
        connection = new SqlConnection(connectionString);
        int recordInserted = 0;
        try
        {
            connection.Open();
            sqlQuery = "IF NOT EXISTS (SELECT * FROM NotificationsSentToAPNS WHERE Restaurant="+ restId +" AND DeviceToken='" + deviceToken + "' AND ActionType='"+actionType+"')";
            sqlQuery += "INSERT INTO NotificationsSentToAPNS (Restaurant, Devicetoken, [Count], ActionType) VALUES ("+restId+",'"+deviceToken+"',"+notificationCount+",'"+actionType+"')";
            sqlQuery += "ELSE ";
	        sqlQuery += "UPDATE NotificationsSentToAPNS SET [Count] = "+notificationCount+", [ReadByDevice] = 0 WHERE DeviceToken='"+deviceToken+"' AND Restaurant="+restId+" AND ActionType='"+actionType+"'";

            sqlCommand = new SqlCommand(sqlQuery, connection);
            recordInserted = sqlCommand.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            //return ex.Message;
        }
        finally
        {
            connection.Close();
        }

        return recordInserted;
    }

    /// <summary>
    /// Sends registered notifications to GCM
    /// </summary>
    public static void sendNotificationToGCM(int RestId, int ActionType, string email)
    {
        Hashtable connectionObject = ServiceHelper.getDBNamesAndConnectionStrings();
        string connectionString = (string)connectionObject["connectionStringApp"];
        SqlConnection connection = null;
        SqlCommand sqlCommand = null;
        SqlDataReader dataReader = null;
        string sql = "";
        connection = new SqlConnection(connectionString);

        try
        {
            if (ServiceHelper.checkNotificationsEnabledByRestByAction(RestId, ActionType))
            {
                switch (ActionType)
                {
                    case 1:
                        //select d1.DeviceRegId as DeviceRegId, count(d1.EventId) AS NotificationCount
                        //from (
                        //    select e.EventID,e.Name,e.Description,e.Date,e.Time,e.Active,d.id,d.RestaurantId,d.DeviceRegId
                        //    from RestaurantEvents As e 
                        //        CROSS JOIN DeviceTokensAndroid AS d 
                        //    where e.Restaurant = 67 AND EmailAddress IS NULL
                        //    ) as d1
                        //    LEFT JOIN(
                        //        select d.id,d.RestaurantId,d.DeviceRegId,v.EventId
                        //        from deviceTokensAndroid as d
                        //            LEFT JOIN RestaurantEventsVisitedAndroid as v on d.id = v.DeviceTokenId
                        //        where d.RestaurantId=67 AND d.EmailAddress IS NULL
                        //        group by d.id,d.RestaurantId,d.DeviceRegId,v.EventId
                        //    ) AS d2
                        //    ON d1.DeviceRegId = d2.DeviceRegId AND d1.EventId = d2.EventId
                        //    Where d2.DeviceRegId IS NULL
                        //    group by d1.DeviceRegId
                        sqlCommand = new SqlCommand("select d1.DeviceRegId as DeviceRegId, count(d1.EventId) AS NotificationCount from ( select e.EventID,e.Name,e.Description,e.Date,e.Time,e.Active,d.id,d.RestaurantId,d.DeviceRegId from RestaurantEvents As e  CROSS JOIN DeviceTokensAndroid AS d  where e.Restaurant = "+RestId+" AND EmailAddress IS NULL ) as d1 LEFT JOIN( select d.id,d.RestaurantId,d.DeviceRegId,v.EventId from deviceTokensAndroid as d LEFT JOIN RestaurantEventsVisitedAndroid as v on d.id = v.DeviceTokenId where d.RestaurantId= "+RestId+" AND d.EmailAddress IS NULL group by d.id,d.RestaurantId,d.DeviceRegId,v.EventId ) AS d2 ON d1.DeviceRegId = d2.DeviceRegId AND d1.EventId = d2.EventId Where d2.DeviceRegId IS NULL group by d1.DeviceRegId", connection);
                        break;
                    case 2:
                        sql = "";
                        break;
                    case 4:
                        sql = "";
                        break;
                }
                connection.Open();
                dataReader = sqlCommand.ExecuteReader();
                while (dataReader.Read())
                {
                    int badgeCount = Convert.ToInt32(dataReader["NotificationCount"]);
                    if (badgeCount > 0)
                    {
                        //send notification to dataReader["DeviceRegid"]

                        // Message to be sent
                        //$message = isset($_GET['message'])?$_GET['message']:"Hello Android!";
                        string message = "{Events: " + badgeCount.ToString() + " }";
                        string responseText = processGCMNotification(dataReader["DeviceRegid"].ToString(), message);
                    }
                }
            }
        }
        catch (Exception ex)
        {

        }
        finally
        {
            connection.Close();
        }
    }

    protected static string processGCMNotification(string deviceId, string message)
    {
        try
        {
            string GoogleAppID = "AIzaSyDbHEnjdbC--mPtgXiT_rtE3vWhqK6LXPs";
            var SENDER_ID = "62903398546";
            var value = message;
            WebRequest tRequest;
            tRequest = WebRequest.Create("https://android.googleapis.com/gcm/send");
            tRequest.Method = "post";
            tRequest.ContentType = " application/x-www-form-urlencoded;charset=UTF-8";
            tRequest.Headers.Add(string.Format("Authorization: key={0}", GoogleAppID));

            //tRequest.Headers.Add(string.Format("Sender: id={0}", SENDER_ID));

            string postData = "collapse_key=score_update&time_to_live=108&delay_while_idle=1&data.message=" + value + "&data.time=" + System.DateTime.Now.ToString() + "&registration_id=" + deviceId + "";
            Console.WriteLine(postData);
            Byte[] byteArray = Encoding.UTF8.GetBytes(postData);
            tRequest.ContentLength = byteArray.Length;

            Stream dataStream = tRequest.GetRequestStream();
            dataStream.Write(byteArray, 0, byteArray.Length);
            dataStream.Close();

            WebResponse tResponse = tRequest.GetResponse();

            dataStream = tResponse.GetResponseStream();

            StreamReader tReader = new StreamReader(dataStream);

            String sResponseFromServer = tReader.ReadToEnd();


            tReader.Close();
            dataStream.Close();
            tResponse.Close();
            return sResponseFromServer;
        }
        catch (Exception e)
        {
            return "error";
        }
        return "error";
    }
}