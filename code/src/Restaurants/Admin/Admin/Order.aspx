<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Order.aspx.cs" Inherits="Restaurants_Admin_Admin_Order_New" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
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
<body>
    <form id="Form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
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
					  OnRowDatabound="GridView1_RowDataBound" 
            >
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
                <asp:BoundField DataField="SubItems" HeaderText="SubItems" SortExpression="SubItems" />
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
</body>
</html>
