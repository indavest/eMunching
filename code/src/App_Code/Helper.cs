using System;
using System.Collections;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Sql;
using System.IO;
using System.Collections.Generic;

/// <summary>
/// Summary description for Helper
/// </summary>
public class Helper
{
	public Helper()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    /// <summary>
    /// Returns the base site URL
    /// </summary>
    public static string BaseSiteUrl
    {
        get
        {
            HttpContext context = HttpContext.Current;
            string baseUrl = context.Request.Url.Scheme + "://" + context.Request.Url.Authority + context.Request.ApplicationPath.TrimEnd('/') + '/';
            return baseUrl;
        }
    }

    /// <summary>
    /// Returns a DB connection object depending on the environment
    /// </summary>
    public static Hashtable getConnectionObject()
    {
        Hashtable connectionString = Helper.getDBNamesAndConnectionStrings();
        Hashtable dbConnectionObj = new Hashtable();
        SqlConnection appConnection = new SqlConnection((string)connectionString["connectionStringApp"]);
        dbConnectionObj.Add("appConnection", appConnection);
        return dbConnectionObj;
    }

    /// <summary>
    /// Reads all the three connection strings from web.config and returns a Hashtable of DB names.
    /// </summary>
    public static Hashtable getDBNamesAndConnectionStrings()
    {
        string environmentType = HttpContext.Current.Request.Url.Host;
        string connectionStringApp;
        switch(environmentType)
        {
            case "dev.emunching.com":
                connectionStringApp = ConfigurationManager.ConnectionStrings["devVCon"].ConnectionString;
                break;

            case "ppe.emunching.com":
                connectionStringApp = ConfigurationManager.ConnectionStrings["ppeVCon"].ConnectionString;
                break;

            case "www.emunching.com":
                connectionStringApp = ConfigurationManager.ConnectionStrings["proVCon"].ConnectionString;
                break;

            default:
                connectionStringApp = ConfigurationManager.ConnectionStrings["localVCon"].ConnectionString;
                break;
    
        }
        
        SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connectionStringApp);
        
        Hashtable catalog = new Hashtable();
        catalog.Add("app", builder.InitialCatalog);
        catalog.Add("connectionStringApp", connectionStringApp);
            
        return catalog;
    }


    /// <summary>
    /// Return DBName and Connection String for Azure Loyalty DB as Hashtable
    /// </summary>
    /// <returns></returns>
    /// 
    public static Hashtable getDBNameAndConnectionStringForLoyalty()
    {
        string connectionStringApp;
        connectionStringApp = ConfigurationManager.ConnectionStrings["loyaltyVCon"].ConnectionString;

        SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connectionStringApp);

        Hashtable catalog = new Hashtable();
        catalog.Add("app", builder.InitialCatalog);
        catalog.Add("connectionStringApp", connectionStringApp);

        return catalog;
    }

    public static bool checkEmailEnabledByRestByAction(int RestId, int ActionType)
    {
        Hashtable connectionObject = Helper.getDBNamesAndConnectionStrings();
        string connectionString = (string)connectionObject["connectionStringApp"];
        SqlConnection connection = new SqlConnection(connectionString);
        SqlCommand command = null;
        bool enabled = false;
        string emailEnabledoptionsFromDB = "";
        try
        {
            connection.Open();
            command = new SqlCommand("SELECT EmailEnabled FROM AdditionalConfig WHERE Restaurant="+RestId, connection);
            emailEnabledoptionsFromDB = (string)command.ExecuteScalar();
            string[] emailEnabledoptionsList = emailEnabledoptionsFromDB.Split(',');
            if (Array.IndexOf(emailEnabledoptionsList, ActionType.ToString()) != -1)
            {
                enabled = true;
            }
        }
        catch (Exception ex)
        {

        }
        finally
        {
            connection.Close();
        }
        return enabled;
    }

    public static bool checkNotificationsEnabledByRestByAction(int RestId, int ActionType)
    {
        Hashtable connectionObject = Helper.getDBNamesAndConnectionStrings();
        string connectionString = (string)connectionObject["connectionStringApp"];
        SqlConnection connection = new SqlConnection(connectionString);
        SqlCommand command = null;
        bool enabled = false;
        string notificationsEnabledoptionsFromDB = "";
        try
        {
            connection.Open();
            command = new SqlCommand("SELECT NotificationsEnabled FROM AdditionalConfig WHERE Restaurant=" + RestId, connection);
            notificationsEnabledoptionsFromDB = (string)command.ExecuteScalar();
            string[] notificationsEnabledoptionsList = notificationsEnabledoptionsFromDB.Split(',');
            if (Array.IndexOf(notificationsEnabledoptionsList, ActionType.ToString()) != -1)
            {
                enabled = true;
            }
        }
        catch (Exception ex)
        {

        }
        finally
        {
            connection.Close();
        }
        return enabled;
    }

    public static Hashtable getAppDisplaySettings(int restaurantId) 
    {
        Hashtable connectionObject = Helper.getDBNamesAndConnectionStrings();
        SqlConnection connection = new SqlConnection(connectionObject["connectionStringApp"].ToString());
        SqlCommand command = null;
        SqlDataReader dataReader = null;
        Hashtable appDisplaySettings = new Hashtable();
        try
        {
            connection.Open();
            command = new SqlCommand("SELECT * FROM MobileAppDisplaySettings WHERE Restaurant=" + restaurantId, connection);
            dataReader = command.ExecuteReader();
            while (dataReader.Read())
            {
                appDisplaySettings.Add(dataReader["EventDealMenu"], dataReader["Type"]);
            }
        }
        catch (Exception ex)
        {

        }
        finally
        {
            connection.Close();
        }
        return appDisplaySettings;
    } 
}