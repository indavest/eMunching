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
    
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        SqlDataSource1.ConnectionString = connectionObject("connectionStringApp")
        SqlDataSource2.ConnectionString = connectionObject("connectionStringApp")
    End Sub
    
	Sub GridView1_RowCommand(sender As Object, e As GridViewCommandEventArgs)
		Dim conn As New SqlConnection(connectionObject("connectionStringApp"))
		Try
			If e.CommandName.Equals("Ack") Then
				Dim btnAck As Button = TryCast(e.CommandSource, Button)
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
				Dim btnClr As Button = TryCast(e.CommandSource, Button)
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
				Dim btnCan As Button = TryCast(e.CommandSource, Button)
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
	body { 
	  background: white url("/images/UIPinStripe.png");
	  background-repeat: repeat;
	  background-position: center;
	}

	#NavButtons 
	{          
	width: 100%;          
	height: 100%;          
	position: fixed;          
	left: 0px;
	top: 0px;
	z-index: -99999;
	color: white;
	font: 25px Palantino, Sans-Serif;font-weight: bolder; text-align:center;
	-webkit-user-select: none;
	-khtml-user-select: none;
	-moz-user-select: none;
	-o-user-select: none;
	user-select: none;
	}      

	#NavButtons img 
	{         
	width:100%;         
	height:100%;     
	} 

	 GridViewStyle
	{    
		border-right: 2px solid #A7A6AA;
		border-bottom: 2px solid #A7A6AA;
		border-left: 2px solid white;
		border-top: 2px solid white;
		padding: 4px;
	}

	.GridViewStyle a
	{
		color: #FFFFFF;
	}

	.GridViewHeaderStyle th
	{
		border-left: 1px solid #EBE9ED;
		border-right: 1px solid #EBE9ED;
	}

	.GridViewHeaderStyle
	{
		background-color: #5D7B9D;
		font-weight: bold;
		color: White;
		font: 25px Palantino, Sans-Serif;font-weight: bolder; text-align:center;
	}

	.GridViewFooterStyle
	{
		background-color: #5D7B9D;
		font-weight: bold;
		color: White;
		font: 25px Palantino, Sans-Serif;font-weight: bolder; text-align:center;
	}

	.GridViewRowStyle
	{
		background-color: #F7F6F3;
		color: #333333;
		font: 23px Palantino, Sans-Serif;font-weight: bolder; text-align:center;
	}

	.GridViewAlternatingRowStyle 
	{
		background-color: #FFFFFF;
		color: #333333;
		font: 23px Palantino, Sans-Serif;font-weight: bolder; text-align:center;
	}

	.GridViewRowStyle td, .GridViewAlternatingRowStyle td
	{
		border: 1px solid #EBE9ED;
	}

	.GridViewSelectedRowStyle
	{
		background-color: #E2DED6;
		font-weight: bold;
		color: #333333;
	}

	.GridViewPagerStyle
	{
		background-color: #284775;
		color: #FFFFFF;
	}

	.GridViewPagerStyle table /* to center the paging links*/
	{
		margin: 0 auto 0 auto;
	}

	.input3
	{
		font: 21px Palantino, Sans-Serif; font-weight: bolder; text-align: center; border: 3px solid black;
	}

	.input2
	{
		font: 19px Palantino, Sans-Serif; font-weight: bolder; text-align: center;
	}

	.input2a
	{
		font: 19px Palantino, Sans-Serif; font-weight: bolder; text-align: center; border: 3px solid black;
	}

	.restbl 
	{
		font: 21px Palantino, Sans-Serif; font-weight: bolder; text-align: left;
	}

	.ButtonCell
	{
	  vertical-align:top;
	}

</style>
</head>
<form runat="server">
<table cellspacing="0" cellpadding="0" border="0" width="99%">
    <tr>
		<td valign="center" align="left">
			<asp:Button ID="btn_refresh" runat="server" Text="Refresh" cssclass="input2a" OnClick="btn_refresh_Click" />
		</td>
		<td valign="top" align="center">
			<asp:label runat="server" id="msg" />
		</td>
		<td valign="top" align="right">
			<asp:LoginStatus ID="LoginStatus1" cssclass="Logout" LogoutAction="Redirect" LogoutPageUrl="/Restaurants/Default.aspx" LogoutImageUrl="~/Images/logout.png" runat="server" />
		</td>
	</tr>
</table>
<br>
        <asp:GridView ID="MasterView1" 
					  runat="server" 
					  AutoGenerateColumns="False" 
					  DataKeyNames="oId"
					  DataSourceID="SqlDataSource1" 
					  EnableViewState="False"
					  GridLines="Both"
					  cellpadding="2"
					  AllowPaging="True" 
					  AllowSorting="True" 
					  CssClass="GridViewStyle"
					  emptydatatext="No data in the data source."
					  PagerStyle-CssClass="pgr"
					  AlternatingRowStyle-CssClass="alt"
					  OnRowCommand="GridView1_RowCommand"
					  OnRowDatabound="GridView1_RowDataBound">
            <Columns>
				<asp:TemplateField >
					<ItemStyle CssClass="ButtonCell" />
					<ItemTemplate>
						<asp:Button ID="Select" CommandName="Select" runat="server" CommandArgument='<%# Bind("oId")%>' cssclass="input2" Text="Select"></asp:Button>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField >
					<ItemTemplate>
						<asp:Button ID="Ack" CommandName="Ack" runat="server" CommandArgument='<%# Bind("oId")%>' cssclass="input2" Text="Ack"></asp:Button>
						<asp:Button ID="Clr" CommandName="Clr" runat="server" CommandArgument='<%# Bind("oId")%>' cssclass="input2" Text="Clear"></asp:Button><br>
						<asp:Button ID="Can" CommandName="Can" runat="server" CommandArgument='<%# Bind("oId")%>' cssclass="input2" Text="Cancel"></asp:Button>
					</ItemTemplate>
				 </asp:TemplateField>
                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
				<asp:BoundField DataField="Phone" HeaderText="Phone" SortExpression="Phone" />
				<asp:BoundField DataField="Placed" HeaderText="Placed" SortExpression="Placed" />
				<asp:BoundField DataField="locationName" HeaderText="Location" SortExpression="locationName" />
                <asp:BoundField DataField="SubTotal" DataFormatString="{0:c}" HeaderText="Sub-Total" HtmlEncode="False" SortExpression="SubTotal" />
				<asp:BoundField DataField="Acked" HeaderText="Acked?" SortExpression="Acked" />
            </Columns>
        </asp:GridView>
		<asp:SqlDataSource ID="SqlDataSource1" 
						   runat="server" 
					       SelectCommand="p_gv_OrdersMaster2 @RestID">
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
						 GridLines="Vertical"
						 cellpadding="3"
						 AllowPaging="True" 
						 AllowSorting="True" 
						 CssClass="GridViewStyle"
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
    </p>
</form>