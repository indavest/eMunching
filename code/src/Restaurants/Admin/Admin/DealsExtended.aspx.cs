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
using FredCK.FCKeditorV2;

public partial class Restaurants_Admin_Admin_DealsExtended : System.Web.UI.Page
{
    Hashtable connectionObject = Helper.getDBNamesAndConnectionStrings();
    protected void Page_Load(object sender, EventArgs e)
    {
        SqlDataSource1.ConnectionString = connectionObject["connectionStringApp"].ToString();
        SqlDataSource AvailItemTypes = new SqlDataSource();
        CreateDataSource(AvailItemTypes, "AvailItemTypes", "SELECT * FROM MenuItemTypes", null);
        SqlDataSource AvailItemTypes2 = new SqlDataSource();
        CreateDataSource(AvailItemTypes2, "AvailItemTypes2", "SELECT * FROM MenuItemTypes", null);
    }

    private void CreateDataSource(SqlDataSource sourceName, string sourceID, string selectCommand, string selectParameter){
        try
        {
            sourceName.ID = sourceID;
            Page.Controls.Add(sourceName);
            sourceName.ConnectionString = connectionObject["connectionStringApp"].ToString();
            sourceName.SelectCommand = selectCommand;
            if (!string.IsNullOrEmpty(selectParameter))
            {
                sourceName.SelectParameters.Add("RestId", selectParameter);
            }
        }
        catch (Exception ex)
        {

        }
        
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
                    SqlCommand command = new SqlCommand("UPDATE dbo.Deals SET active=1 WHERE id=" + e.CommandArgument + " AND Restaurant=" + Session["RestID"], conn);
                    conn.Open();
                    if (command.ExecuteNonQuery() == 1)
                    {
                        GridView1.DataBind();
                        conn.Close();

                        if (Helper.checkNotificationsEnabledByRestByAction((Int32)Session["RestID"], 2))
                        {
                            NotificationHelper.registerNotification((Int32)Session["RestID"], "Deal");
                        }
                        string restName = Session["RestName"].ToString();
                        string fromAdd = "Deals@" + restName + ".emunching.com";
                        string subject = "RE: New Deal Alert from " + restName + "!";
                        objCmd = new SqlCommand("SELECT MPU.ID,d.description FROM dbo.MobileAppUsers MPU, dbo.Deals d WHERE MPU.ID NOT LIKE '%call.in%' AND MPU.RestaurantID = " + Session["RestId"] + " AND d.id=" + e.CommandArgument, conn);
                        conn.Open();
                        dataReader = objCmd.ExecuteReader();

                        while (dataReader.Read())
                        {
                            string msgBody = dataReader["description"].ToString();
                            msgBody = msgBody.Replace("&lt;", "<");
                            msgBody = msgBody.Replace("&gt;", ">");
                            msgBody = msgBody.Replace("&amp;", "&");
                            msgBody = msgBody.Replace("&#39;", "");
                            if (Helper.checkEmailEnabledByRestByAction((Int32)Session["RestID"], 1))
                            {
                                MailHelper.SendMail(dataReader["ID"].ToString(), "", subject, msgBody, fromAdd, restName);
                            }
                        }

                    }
                    break;
                case "Delete":
                    objCmd = new SqlCommand("DELETE FROM dbo.RestaurantEvents WHERE EventID=" + e.CommandArgument + " AND Restaurant=" + Session["RestID"], conn);
                    conn.Open();
                    if (objCmd.ExecuteNonQuery() == 1)
                    {
                        GridView1.DataBind();
                        conn.Close();
                    }
                    break;
            }
        }
        catch (Exception ex)
        {
        }
    }

    public void updateRecord(Object sender, GridViewUpdateEventArgs e)
    {
        SqlConnection conn = new SqlConnection(connectionObject["connectionStringApp"].ToString());
        GridViewRow row = GridView1.Rows[e.RowIndex];
        TextBox title = (TextBox)(row.FindControl("Title"));
        FCKeditor description = (FCKeditor)(row.FindControl("Description"));
        TextBox startsFrom = (TextBox)(row.FindControl("startsFrom"));
        TextBox ExpiresOn = (TextBox)(row.FindControl("ExpiresOn"));
        DropDownList DealType = (DropDownList)(row.FindControl("MenuType"));
        FCKeditor teaser = (FCKeditor)(row.FindControl("Teaser"));
        HiddenField DealID = (HiddenField)(row.FindControl("DealID"));
        SqlCommand command = new SqlCommand("p_gv_UpdateDeals @RestID,@id,@Title,@Description,@StartsFrom,@ExpiresOn,@DealType,@Teaser", conn);
        command.Parameters.AddWithValue("RestID", Session["RestID"]);
        command.Parameters.AddWithValue("id", DealID.Value);
        command.Parameters.AddWithValue("Title", title.Text);
        command.Parameters.AddWithValue("Description", Server.HtmlEncode(description.Value));
        command.Parameters.AddWithValue("StartsFrom", startsFrom.Text);
        command.Parameters.AddWithValue("ExpiresOn", ExpiresOn.Text);
        command.Parameters.AddWithValue("DealType", DealType.SelectedItem.Value);
        command.Parameters.AddWithValue("Teaser", Server.HtmlEncode(teaser.Value));
        conn.Open();
        if (command.ExecuteNonQuery() == 1)
        {
            GridView1.DataBind();
            Response.Redirect("DealsExtended.aspx");
        }
    }

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        SqlConnection objConn = new SqlConnection(connectionObject["connectionStringApp"].ToString());
        SqlCommand objCmd = null;
        string sqlCmd = "";
        int recordInserted = 0;
        sqlCmd = "EXECUTE p_CreateDeal '" + Session["RestID"] + "','" + txtDealTitle.Text + "','" + Server.HtmlEncode(CKEditor1.Value) + "', '" + txtDealStartDte.Text + "', '" + txtDealStopDte.Text + "','" + MenuType2.SelectedValue + "','" + Server.HtmlEncode(FCKEditor2.Value) + "'";
        objCmd = new SqlCommand(sqlCmd, objConn);
        objConn.Open();
        recordInserted = objCmd.ExecuteNonQuery();
        objConn.Close();
        Response.Redirect("DealsExtended.aspx");
    }

    public string ConvertFormattedString(string FStr){
        string ProcessedHTMLa = "";
		ProcessedHTMLa = Server.HtmlDecode(FStr);
        return ProcessedHTMLa;
    }
	
}