using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Utilities;
using System.Text.RegularExpressions;

public partial class Features : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void submit_Click(object sender, EventArgs e)
    {
        int error = 0;
        string name = knowMoreName.Text;
        string email = knowMoreEMail.Text;
        string restaurantName = knowMoreRestName.Text;
        string contactNumberCountry = knowMoreContactCountry.Text;
        string contactNumberArea = knowMoreContactArea.Text;
        string contactNumber = knowMoreContactNumber.Text;
        string comments = knowMoreComments.Text;
        string pattern = null;
        pattern = "^([0-9a-zA-Z]([-\\.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})$";

        if (string.IsNullOrEmpty(name))
        {
            error++;
            errorMsg.Text = "Please fill Name before Submit";
        }
        else if(string.IsNullOrEmpty(email) || !Regex.IsMatch(email, pattern))
        {
            errorMsg.Text = "Please use valid email";
        }
        else
        {
            string subject = "<p><b>New Request</b></p><p>Name: " + name + "<br>Email: " + email + "<br>Restaurant: " + restaurantName + "<br>Contact Number: " + contactNumberCountry + "-" + contactNumberArea + "-" + contactNumber + "<br>Comments: " + comments + "</p>";
            try
            {
                if (MailHelper.SendMail("contact@emunching.com", "", "New Lead", subject, "info@emunching.com", "eMunching"))
                {
                    Response.Redirect("/Thankyou.aspx");
                }

            }
            catch (Exception ex)
            {
                Trace.Write(ex.Message);
            }
        }

    }
}