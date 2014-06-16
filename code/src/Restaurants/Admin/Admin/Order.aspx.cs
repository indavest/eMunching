using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;

public partial class Restaurants_Admin_Admin_Order_New : System.Web.UI.Page
{
    private Hashtable connectionObject = Helper.getDBNamesAndConnectionStrings();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        SqlDataSource1.ConnectionString = (string)connectionObject["connectionStringApp"];
        SqlDataSource2.ConnectionString = (string)connectionObject["connectionStringApp"];
        if(!Page.IsPostBack){
            getOrdersCCAddress();
        }
    }

    private void getOrdersCCAddress()
    {
        DataTable dt = new DataTable();
        SqlConnection connection = new SqlConnection((string)connectionObject["connectionStringApp"]);
		connection.Open();
        SqlCommand sqlCmd = new SqlCommand("EXEC p_GetOrdersCCAddress @RestID", connection);
        SqlDataAdapter sqlDa = new SqlDataAdapter(sqlCmd);
        
		sqlCmd.Parameters.AddWithValue("@RestID", Session["RestID"]);
		sqlDa.Fill(dt);
		if(dt.Rows.Count > 0)
        {
            OrdersCCAddress.Text = dt.Rows[0]["OrdersCCAddress"].ToString();
        }
		connection.Close();
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        SqlConnection conn = new SqlConnection((string)connectionObject["connectionStringApp"]);
        try {
        	if(e.CommandName.Equals("Ack"))
            {
                LinkButton btnAck = (LinkButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btnAck.NamingContainer;
                SqlCommand cmd = new SqlCommand("p_gv_OrderAck @OrderID", conn);
                cmd.Parameters.AddWithValue("OrderID", e.CommandArgument);
				conn.Open();
				if(cmd.ExecuteNonQuery() > 1)
                {
                    MasterView1.DataBind();
                }
					
			} 
            else if(e.CommandName.Equals("Clr"))
            {
                LinkButton btnClr = (LinkButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btnClr.NamingContainer;
                
                SqlCommand cmd = new SqlCommand("p_gv_OrderClr @OrderID", conn);
                cmd.Parameters.AddWithValue("OrderID", e.CommandArgument);
				conn.Open();
				if(cmd.ExecuteNonQuery() > 0)
                {
                    MasterView1.DataBind();
                }
            }
            else if(e.CommandName.Equals("Can"))
            {
                LinkButton btnCan = (LinkButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btnCan.NamingContainer;
                //if(!row)
                //{
                //   return;    
                //}
				
                SqlCommand cmd = new SqlCommand("p_gv_OrderCan @OrderID", conn);
                cmd.Parameters.AddWithValue("OrderID", e.CommandArgument);
				conn.Open();
				if( cmd.ExecuteNonQuery() > 0){
                    MasterView1.DataBind();
                }
			}
            else if (e.CommandName.Equals("Select"))
            {
                string orderId = e.CommandArgument.ToString();
                SqlCommand cmd = new SqlCommand("p_gv_OrdersDetails @oId", conn);
                cmd.Parameters.AddWithValue("oId", orderId);
                conn.Open();
                SqlDataReader dataReader = cmd.ExecuteReader();
                
                if (dataReader.HasRows)
                {
                    DetailsView1.DataSource = dataReader;
                    DetailsView1.DataBind();
                }
            }
		}
		catch(Exception ex){
            msg.Text = ex.Message;
        }
		finally{
            conn.Close();
        }
    }

    protected void SubmitButton2_Click(object sender, EventArgs e)
    {
        SqlConnection objConn = new SqlConnection((string)connectionObject["connectionStringApp"]);
        SqlCommand objCmd = null;
        string sqlCmd = null;
        		
		sqlCmd = "EXECUTE p_SetOrdersCCAddress '" + Session["RestID"] + "','" + OrdersCCAddress.Text + "'";

		objCmd = new SqlCommand(sqlCmd, objConn);
		objConn.Open();
		objCmd.ExecuteNonQuery();
		objConn.Close();

		Response.Redirect("Order.aspx");
    }

    protected void GridView1_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
    {
        if(e.Row.RowType == DataControlRowType.DataRow)
        {
            if(e.Row.Cells[7].Text == "ACKNOWLEDGED"){
                e.Row.Cells[7].ForeColor = System.Drawing.Color.White;
                e.Row.Cells[7].BackColor = System.Drawing.Color.Green;
            }else if(e.Row.Cells[7].Text == "NO"){
                e.Row.Cells[7].ForeColor = System.Drawing.Color.Yellow;
                e.Row.Cells[7].BackColor = System.Drawing.Color.Crimson;
            }
        }
    }

    protected void btn_refresh_Click(object sender, EventArgs e)
    {
        MasterView1.DataBind();
    }
}