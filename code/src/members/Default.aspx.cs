using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class members_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
		if (User.IsInRole("TMG Cafe Admin")) {
			Response.Redirect("~/Restaurants/TMG Cafe/Admin/default.aspx");
		}

    }
}
