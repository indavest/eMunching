<%@ Page Language="VB" debug="true"%>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<script runat="server">
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        SqlDataSource1.ConnectionString = connectionObject("connectionStringApp")
        SqlDataSource2.ConnectionString = connectionObject("connectionStringApp")
        If Not Page.IsPostBack Then
            getOrdersCCAddress()
        End If
    End Sub

	Private Sub getOrdersCCAddress()
        Dim dt As New DataTable()
        
		Dim connection As New SqlConnection(connectionObject("connectionStringApp"))
		connection.Open()
		Dim sqlCmd As New SqlCommand("EXEC p_GetOrdersCCAddress @RestID", connection)
		Dim sqlDa As New SqlDataAdapter(sqlCmd)
	   
		sqlCmd.Parameters.AddWithValue("@RestID", Session("RestID"))
		sqlDa.Fill(dt)
		If dt.Rows.Count > 0 Then
			OrdersCCAddress.Text = dt.Rows(0)("OrdersCCAddress").ToString()
		End If
		connection.Close()
	End Sub
	
	Sub GridView1_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
        Dim conn As New SqlConnection(connectionObject("connectionStringApp"))
		Try
			If e.CommandName.Equals("Ack") Then
				Dim btnAck As LinkButton = TryCast(e.CommandSource, LinkButton)
				Dim row As GridViewRow = TryCast(btnAck.NamingContainer, GridViewRow)
				If row Is Nothing Then
					Return
				End If
				'Dim thisID As String = MasterView1.DataKeys(e.CommandArgument).Value.ToString()
				Dim cmd As New SqlCommand("p_gv_OrderAck @OrderID", conn)
				cmd.Parameters.AddWithValue("OrderID", e.CommandArgument)
				conn.Open()
				If cmd.ExecuteNonQuery() = 1 Then
					MasterView1.DataBind()
				End If
			ElseIf e.CommandName.Equals("Clr") Then
				Dim btnClr As LinkButton = TryCast(e.CommandSource, LinkButton)
				Dim row As GridViewRow = TryCast(btnClr.NamingContainer, GridViewRow)
				If row Is Nothing Then
					Return
				End If
				
				Dim cmd As New SqlCommand("p_gv_OrderClr @OrderID", conn)
				cmd.Parameters.AddWithValue("OrderID", e.CommandArgument)
				conn.Open()
				If cmd.ExecuteNonQuery() = 1 Then
					MasterView1.DataBind()
				End If

			ElseIf e.CommandName.Equals("Can") Then
				Dim btnCan As LinkButton = TryCast(e.CommandSource, LinkButton)
				Dim row As GridViewRow = TryCast(btnCan.NamingContainer, GridViewRow)
				If row Is Nothing Then
					Return
				End If
				
				Dim cmd As New SqlCommand("p_gv_OrderCan @OrderID", conn)
				cmd.Parameters.AddWithValue("OrderID", e.CommandArgument)
				conn.Open()
				If cmd.ExecuteNonQuery() = 1 Then
					MasterView1.DataBind()
				End If

			End If

		Catch ex As Exception
			msg.text = ex.message
		Finally
			conn.Close()
		End Try
	End Sub

	Protected Sub SubmitButton2_Click(sender As Object, e As EventArgs)

		Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
        Dim objConn As New SqlConnection(connectionObject("connectionStringApp"))
		Dim objCmd As SQLCommand
		Dim sqlCmd As String
				
		sqlCmd = "EXECUTE p_SetOrdersCCAddress '" & Session("RestID") & "','" & _
													OrdersCCAddress.Text & "'"

		objCmd = New SQLCommand(sqlCmd, objConn)
		objConn.Open()
		objCmd.ExecuteNonQuery()
		objConn.Close()

		Response.Redirect("Order.aspx")

	End Sub

	Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            If e.Row.Cells(7).Text = "ACKNOWLEDGED" Then
				e.Row.Cells(7).ForeColor = Drawing.Color.White
                e.Row.Cells(7).BackColor = Drawing.Color.Green
			ElseIf e.Row.Cells(7).Text = "NO" Then
				e.Row.Cells(7).ForeColor = Drawing.Color.Yellow
                e.Row.Cells(7).BackColor = Drawing.Color.Crimson
            End If
        End If
    End Sub

	Protected Sub btn_refresh_Click(sender As Object, e As EventArgs)
		MasterView1.DataBind()
	End Sub
</script>
<head>
	<style type="text/css">
		* {
			padding: 0; 
			margin: 0; 
		}
		body {
			font: 9px Tahoma;
			background-color: #CCCCCC /*#F7F7E9*/;
		}
		h1 {
			font: bold 32px Times;
			color: #666;
			text-align: center;
			padding: 20px 0;    
		}
		#container {
			/*width: 750px;*/
			margin: 10px auto;
		}

		.mGrid { width: 100%; background-color: #fff; margin: 5px 0 10px 0; border: solid 1px #525252; border-collapse:collapse; font: 11px Tahoma;}
		.mGrid td { padding: 2px; border: solid 1px #c1c1c1; color: #717171; font: 11px Tahoma;}
		.mGrid th { padding: 4px 2px; color: #fff; background: #424242 url(./images/grd_head.png) repeat-x top; border-left: solid 1px #525252; }
		.mGrid th a { color: #eeeeee; text-decoration: none; }
		.mGrid .alt { background: #fcfcfc url(./images/grd_alt.png) repeat-x top; }
		.mGrid .pgr {background: #424242 url(./images/grd_pgr.png) repeat-x top; }
		.mGrid .pgr table { margin: 5px 0; }
		.mGrid .pgr td { border-width: 0; padding: 0 6px; border-left: solid 1px #666; font-weight: bold; color: #fff; line-height: 12px; }   
		.mGrid .pgr a { color: #eeeeee; text-decoration: none; }
		.mGrid .pgr a:hover { color: #000; text-decoration: none; }
		.input {border: solid black 1px; font: 11px Tahoma;}
		.lblMoney {text-align: right;}
	</style>
</head>
<form runat="server">
<ajaxToolkit:ToolkitScriptManager runat="Server" EnableScriptGlobalization="true"  EnableScriptLocalization="true" ID="ScriptManager1" />
	<h3>Orders</h3>
	If others email addresses should be copied on all incoming orders, please enter the email addresses below. Multiple email addresses should be seperated by a semi-colon (;)<br>
	<asp:TextBox ID="OrdersCCAddress" runat="server" cssclass="input" size="39"></asp:TextBox>&nbsp;&nbsp;&nbsp;<asp:Button	id="btnSubmit2" Text="Save" Runat="server" cssclass="input" onclick="SubmitButton2_Click" />
	<br>
    <h4>View Orders</h4>
	<p><asp:label runat="server" id="msg" /></p>
    <p>
	<asp:Button ID="btn_refresh" runat="server" Text="Refresh" cssclass="input" OnClick="btn_refresh_Click" />

	<asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
	<ContentTemplate>
        <asp:GridView ID="MasterView1" 
					  runat="server" 
					  AutoGenerateColumns="False" 
					  DataKeyNames="oId"
					  DataSourceID="SqlDataSource1" 
					  EnableViewState="False"
					  GridLines="None"
					  AllowPaging="True" 
					  AllowSorting="True" 
					  CssClass="mGrid"
					  emptydatatext="No data in the data source."
					  PagerStyle-CssClass="pgr"
					  AlternatingRowStyle-CssClass="alt"
					  OnRowCommand="GridView1_RowCommand"
					  OnRowDatabound="GridView1_RowDataBound">
            <Columns>
                <asp:CommandField ShowSelectButton="True" />
				<asp:TemplateField >
					<ItemTemplate>
						<asp:LinkButton ID="Ack" CommandName="Ack" runat="server" CommandArgument='<%# Bind("oId")%>' Text="Ack"></asp:LinkButton>
						<asp:LinkButton ID="Clr" CommandName="Clr" runat="server" CommandArgument='<%# Bind("oId")%>' Text="Clear"></asp:LinkButton>
						<asp:LinkButton ID="Can" CommandName="Can" runat="server" CommandArgument='<%# Bind("oId")%>' Text="Cancel"></asp:LinkButton>
					</ItemTemplate>
				 </asp:TemplateField>
                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
				<asp:BoundField DataField="Phone" HeaderText="Phone" SortExpression="Phone" />
				<asp:BoundField DataField="OrderName" HeaderText="Order Name" SortExpression="OrderName" />
				<asp:BoundField DataField="Placed" HeaderText="Placed" SortExpression="Placed" />
				<asp:BoundField DataField="locationName" HeaderText="Location" SortExpression="locationName" />
                <asp:BoundField DataField="SubTotal" HeaderText="Sub-Total" HtmlEncode="False" SortExpression="SubTotal" />
				<asp:BoundField DataField="Acked" HeaderText="Acked?" SortExpression="Acked" />
            </Columns>
        </asp:GridView>
		<asp:SqlDataSource ID="SqlDataSource1" 
						   runat="server" 
					       SelectCommand="p_gv_OrdersMaster @RestID">
			<SelectParameters>
			  <asp:sessionparameter name="RestID" sessionfield="RestID" /> 
			</SelectParameters>
		</asp:SqlDataSource>
    </p>
	<br>
	<h3>Selected Order Details</h3>
	<p>
        <asp:GridView ID="DetailsView1" 
						 runat="server" 
						 AutoGenerateColumns="False" 
						 DataKeyNames="oId"
						 DataSourceID="SqlDataSource2" 
						 EnableViewState="False"
						 GridLines="None"
						 AllowPaging="True" 
						 AllowSorting="True" 
						 CssClass="mGrid"
					     emptydatatext="No data in the data source."
					     PagerStyle-CssClass="pgr"
					     AlternatingRowStyle-CssClass="alt">
            <Columns>
                <asp:BoundField DataField="Item" HeaderText="Item" SortExpression="Item" />
                <asp:BoundField DataField="Quantity" HeaderText="Qty/Item" SortExpression="Quantity" />
                <asp:BoundField DataField="ItemPriceA" HeaderText="Price" SortExpression="ItemPriceA" />
            </Columns>
        </asp:GridView>
		<asp:SqlDataSource ID="SqlDataSource2" 
						   runat="server" 
					       SelectCommand="p_gv_OrdersDetails @oId">
			<SelectParameters>
			  <asp:ControlParameter ControlID="MasterView1" Name="oId" PropertyName="SelectedValue" />
			</SelectParameters>
		</asp:SqlDataSource>
		</ContentTemplate>
	<Triggers>
		<asp:AsyncPostBackTrigger ControlID="btn_refresh" EventName="Click"></asp:AsyncPostBackTrigger>
	</Triggers>
	</asp:UpdatePanel>
    </p>

</form>