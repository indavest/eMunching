using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using Utilities;

public partial class Restaurants_Admin_Admin_EventsExtended : System.Web.UI.Page
{
    Hashtable connectionObject = Helper.getDBNamesAndConnectionStrings();
    Hashtable appDisplaySetting = null;
    protected void Page_Load(object sender, EventArgs e)
    {
        appDisplaySetting = Helper.getAppDisplaySettings(Convert.ToInt32(Session["RestID"]));
        AvailRestLocas.ConnectionString = connectionObject["connectionStringApp"].ToString();
        SqlDataSource1.ConnectionString = connectionObject["connectionStringApp"].ToString();
    }

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        SqlConnection objConn = new SqlConnection(connectionObject["connectionStringApp"].ToString());
		SqlCommand objCmd = null;
		string sqlCmd = "";
        int insertedRecord = 0;
        
        sqlCmd = "EXECUTE p_gv_CreateEvent '" + Session["RestID"] + "','" + ddlEventLoca.SelectedItem.Value + "', '" + txtEventName.Text + "', '" +Server.HtmlEncode(CKEditor1.Value) + "', '" + txtEventDte.Text + "', '" + ddlEventTime.SelectedItem.Value + "','" + Server.HtmlEncode(CKEditor1.Value) + "'";
		
		objCmd = new SqlCommand(sqlCmd, objConn);
        objConn.Open();
        insertedRecord = objCmd.ExecuteNonQuery();
        objConn.Close();
        if ((Int32)appDisplaySetting["Event"] == 2)
        {
            Response.Redirect("EventsExtended.aspx");
        }
        else
        {
            Response.Redirect("Events.aspx");
        }
        
    }

    public string ConvertFormattedString(string FStr){
        string ProcessedHTMLa = "";
        ProcessedHTMLa = Server.HtmlDecode(FStr);
        return ProcessedHTMLa;
    }

    public void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        SqlConnection conn = new SqlConnection(connectionObject["connectionStringApp"].ToString());
        SqlCommand objCmd = null;
        SqlDataReader dataReader = null;
        try
        {
            string Action = e.CommandName;
            switch (Action)
            {
                case "Publish":
                    SqlCommand command = new SqlCommand("UPDATE dbo.RestaurantEvents SET Active=1 WHERE EventID=" + e.CommandArgument + " AND Restaurant=" + Session["RestID"], conn);
                    conn.Open();
                    if(command.ExecuteNonQuery() == 1){
                        GridView1.DataBind();
                        conn.Close();
                        
                        if(Helper.checkNotificationsEnabledByRestByAction((Int32)Session["RestID"], 1)){
                            NotificationHelper.registerNotification((Int32)Session["RestID"], "Event");        
                        }
                        string restName = Session["RestName"].ToString();
                        string fromAdd = "Events@" + restName + ".emunching.com";
                        string subject = "RE: New Event Alert from " + restName + "!";
                        objCmd = new SqlCommand("SELECT MPU.ID,e.Description FROM dbo.MobileAppUsers MPU, dbo.RestaurantEvents e WHERE MPU.ID NOT LIKE '%call.in%' AND MPU.RestaurantID = " + Session["RestId"] + " AND e.EventID=" + e.CommandArgument, conn);
                        conn.Open();
                        dataReader = objCmd.ExecuteReader();
                        
                        while(dataReader.Read())
                        {
                            string msgBody = dataReader["description"].ToString();
                            msgBody = msgBody.Replace("&lt;", "<");
                            msgBody = msgBody.Replace("&gt;", ">");
                            msgBody = msgBody.Replace("&amp;", "&");
                            msgBody = msgBody.Replace("&#39;", "");
                            if(Helper.checkEmailEnabledByRestByAction((Int32)Session["RestID"], 1)){
                                MailHelper.SendMail(dataReader["ID"].ToString(), "", subject, msgBody, fromAdd, restName);        
                            }
                        }
                        
                    }
                    break;
                case "Delete":
                    objCmd = new SqlCommand("DELETE FROM RestaurantEvents WHERE EventID=" + e.CommandArgument + " AND Restaurant=" + Session["RestID"], conn);
                    conn.Open();
                    if (objCmd.ExecuteNonQuery() == 1)
                    {
                        GridView1.DataBind();
                        conn.Close();
                    }
                    break;
            }
        }
        catch(Exception ex)
        {
        }
    }
    
}