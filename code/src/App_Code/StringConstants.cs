using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;
using System.Data.SqlClient;
using System.Data;

/// <summary>
/// Summary description for Class1
/// </summary>
public class StringConstants
{
    public const string RESTAURANT_ADMIN_PATH = "~/Restaurants/Admin/Admin/default.aspx";
    static Hashtable connectionObject = Helper.getDBNamesAndConnectionStrings();
    public const string RESTAURANT_PAYLOAD_PATH = "E:/Projects/emunching/Payload/CouponCodes/";
    //public string RESTAURANT_MENU_IMAGE_PATH = "~/Restaurants/" + System.Web.HttpContext.Current.Session["RestName"].ToString() + "/ArtWork/MenuItems/";
    
	
    public StringConstants()
	{
        //
		// TODO: Add constructor logic here
		//
	}

    public static Hashtable GetNotificationSetting()
    {
        SqlConnection connection = new SqlConnection((string)connectionObject["connectionStringApp"]);
        SqlCommand sqlCommand = null;
        SqlDataReader dataReader = null;
        Hashtable NotificationOptions = new Hashtable();
        try
        {
            connection.Open();
            sqlCommand = new SqlCommand("SELECT * FROM dbo.NotificationTypes", connection);
            dataReader = sqlCommand.ExecuteReader();
            while (dataReader.Read())
            {
                NotificationOptions.Add(dataReader["NotificationTypeID"], dataReader["Name"]);
            }
            
        }
        catch (Exception ex)
        {
        }
        finally
        {
            connection.Close();
        }

        return NotificationOptions;
    }

    public static Hashtable GetEmailOptions()
    {
        SqlConnection connection = new SqlConnection((string)connectionObject["connectionStringApp"]);
        SqlCommand sqlCommand = null;
        SqlDataReader dataReader = null;
        Hashtable EmailOptions = new Hashtable();
        try
        {
            connection.Open();
            sqlCommand = new SqlCommand("SELECT * FROM dbo.EmailOptions ORDER BY EmailOptionID ASC", connection);
            dataReader = sqlCommand.ExecuteReader();
            while (dataReader.Read())
            {
                EmailOptions.Add(dataReader["EmailOptionID"], dataReader["Name"]);
            }

        }
        catch (Exception ex)
        {
        }
        finally
        {
            connection.Close();
        }

        return EmailOptions;
    }
}