using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Data;
using System.Collections;
using System.IO;

public partial class admin_controls_restaurantAdditonalSettings : System.Web.UI.UserControl
{
    private Hashtable connectionObject = Helper.getDBNamesAndConnectionStrings();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            string connectionString = (string)connectionObject["connectionStringApp"];
            SqlConnection connection = new SqlConnection(connectionString);
            SqlCommand command = null;
            SqlDataReader dataReader = null;
            try
            {
                connection.Open();
                string RestId = Request.QueryString["RestId"];
                Session["RestId"] = RestId;
                command = new SqlCommand("SELECT r.name,ac.* FROM Restaurant r, AdditionalConfig ac WHERE r.id=ac.Restaurant AND r.id=" + RestId, connection);
                dataReader = command.ExecuteReader();
                Hashtable notificationOptions = StringConstants.GetNotificationSetting();
                Hashtable emailOptions = StringConstants.GetEmailOptions();
                while (dataReader.Read())
                {
                    reataurantName.Text = (string)dataReader["name"];
                    string emailOptionsEnabledFromDB = dataReader["EmailEnabled"].ToString();
                    string[] emailOPtionsEnabledList = emailOptionsEnabledFromDB.Split(',');
                    string notificationsEnabledFromDB = dataReader["NotificationsEnabled"].ToString();
                    string[] notificationsEnabledList = notificationsEnabledFromDB.Split(',');
                    string notificationCertificate = dataReader["NotificationCertificate"].ToString();
                    //Preparing Email options
                    foreach (int emailOption in emailOptions.Keys)
                    {
                        string listoption = (string)emailOptions[emailOption];
                        ListItem emailOptionItem = new ListItem(listoption);
                        if (Array.IndexOf(emailOPtionsEnabledList, emailOption.ToString()) != -1)
                        {
                            emailOptionItem.Selected = true;
                        }
                        emailOptionItem.Value = emailOption.ToString();
                        emailOptionList.Items.Add(emailOptionItem);
                    }

                    //Preparing Notification options
                    foreach (int notificationOption in notificationOptions.Keys)
                    {
                        string listoption = (string)notificationOptions[notificationOption];
                        ListItem notificationItem = new ListItem(listoption);
                        if (Array.IndexOf(notificationsEnabledList, notificationOption.ToString()) != -1)
                        {
                            notificationItem.Selected = true;
                        }
                        notificationItem.Value = notificationOption.ToString();
                        notificationOptionList.Items.Add(notificationItem);
                    }
                    if(!string.IsNullOrEmpty(notificationCertificate))
                    {
                        certificateLabel.Text = notificationCertificate;
                    }
                }
            }
            catch (Exception ex)
            {
                msg.Text = ex.Message;
            }
            finally
            {
                connection.Close();
            }
        }
        
    }

    protected void Save_Click(object sender, EventArgs e)
    {
        string connectionString = (string)connectionObject["connectionStringApp"];
        SqlConnection connection = new SqlConnection(connectionString);
        SqlCommand command = null;
        string emailOptionsEnabled = "";
        string notificationsEnabled = "";
        string restId = Request.QueryString["RestId"];
        foreach(ListItem listItem in emailOptionList.Items)
        {
            if (listItem.Selected)
            {
                emailOptionsEnabled += listItem.Value + ",";
            }
        }
        emailOptionsEnabled = emailOptionsEnabled.TrimEnd(',');
        foreach (ListItem listItem in notificationOptionList.Items)
        {
            if (listItem.Selected)
            {
                notificationsEnabled += listItem.Value + ",";
            }
        }
        notificationsEnabled = notificationsEnabled.TrimEnd(',');
        try
        {
            string certificateFileName = null;
            if (uploadCertificate.PostedFile.FileName != "")
            {
                certificateFileName = Path.GetFileName(uploadCertificate.PostedFile.FileName);
                uploadCertificate.PostedFile.SaveAs(Request.PhysicalApplicationPath + "certificates/" + certificateFileName);
            }
            connection.Open();
            command = new SqlCommand("UPDATE [dbo].[AdditionalConfig] SET EmailEnabled='" + ((emailOptionsEnabled != "")?emailOptionsEnabled:"0") + "', NotificationsEnabled='" + ((notificationsEnabled != "")?notificationsEnabled:"0") + "', NotificationCertificate='"+certificateFileName+"' WHERE Restaurant=" + restId, connection);
            if (command.ExecuteNonQuery() > 0)
            {
                Response.Redirect("RestaurantEditor.aspx");
            }
        }
        catch (Exception ex)
        {
            msg.Text = ex.Message;
        }
        finally
        {
            connection.Close();
        }
    }
}