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
        Dim AvailLocations As New SqlDataSource
        CreateDataSource(AvailLocations, "AvailLocations", "p_gv_GetRestaurantLocations @RestID", Session("RestID"))
        dsUsers.ConnectionString = connectionObject("connectionStringApp")
        If Not Page.IsPostBack Then
            getUserRegCCAddress()
        End If
    End Sub

    Private Sub CreateDataSource(ByVal sourceName As SqlDataSource, ByVal sourceID As String, ByVal selectCommand As String, ByVal selectParameter As Integer)
        sourceName.ID = sourceID
        sourceName.ConnectionString = connectionObject("connectionStringApp")
        sourceName.SelectCommand = selectCommand
        If Not String.IsNullOrEmpty(selectParameter) Then
            sourceName.SelectParameters.Add("RestId", selectParameter)
        End If
        Me.Page.Controls.Add(sourceName)
    End Sub
    
	Sub GridView1_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        Dim conn As New SqlConnection(connectionObject("connectionStringApp"))
		Try
			If e.CommandName.Equals("ResPwd") Then
				Dim btnRP As Button = TryCast(e.CommandSource, Button)
				Dim row As GridViewRow = TryCast(btnRP.NamingContainer, GridViewRow)
				If row Is Nothing Then
					Return
				End If
				'Dim thisID As String = MasterView1.DataKeys(e.CommandArgument).Value.ToString()
				Dim cmd As New SqlCommand("p_Svc_GetForgottenPwd @ID,@RestID", conn)
				cmd.Parameters.AddWithValue("ID", e.CommandArgument)
				cmd.Parameters.AddWithValue("RestID", Session("RestID"))
				conn.Open()
				If cmd.ExecuteNonQuery() = 1 Then
					GridView1.DataBind()
				End If
				msg.Text = "The password for " + e.CommandArgument + " has been successfully sent."
			End If

		Catch ex As Exception
			msg.text = ex.message
		Finally
			conn.Close()
		End Try
	End Sub

	Private Sub getUserRegCCAddress()
        Dim dt As New DataTable()
        Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
		Dim connection As New SqlConnection(connectionObject("connectionStringApp"))
		connection.Open()
		Dim sqlCmd As New SqlCommand("EXEC p_GetUserRegCCAddress @RestID", connection)
		Dim sqlDa As New SqlDataAdapter(sqlCmd)
	   
		sqlCmd.Parameters.AddWithValue("@RestID", Session("RestID"))
		sqlDa.Fill(dt)
		If dt.Rows.Count > 0 Then
			UserRegCCAddress.Text = dt.Rows(0)("UserRegCCAddress").ToString()
		End If
		connection.Close()
	End Sub

	Protected Sub SubmitButton2_Click(sender As Object, e As EventArgs)

		Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
        Dim objConn As New SqlConnection(connectionObject("connectionStringApp"))
		Dim objCmd As SQLCommand
		Dim sqlCmd As String
				
		sqlCmd = "EXECUTE p_SetUserRegCCAddress '" & Session("RestID") & "','" & UserRegCCAddress.Text & "'"

		objCmd = New SQLCommand(sqlCmd, objConn)
		objConn.Open()
		objCmd.ExecuteNonQuery()
		objConn.Close()

		Response.Redirect("UserMgmt.aspx")

	End Sub

</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us">
<head runat="server">
<title>Admin Control Panel</title>
<script type="text/javascript" src="/js/carousel/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/js/carousel/jquery.jcarousel.min.js"></script>
<script type="text/javascript" src="/js/ShowHide.js"></script>
<link rel="stylesheet" type="text/css" href="/themes/skin2.css" />
<link rel="stylesheet" type="text/css" href="/themes/skin1.css" />
<link rel="stylesheet" type="text/css" href="/themes/stickyfooter.css" />
<script type="text/javascript">
	jQuery(document).ready(function() {
		jQuery('#mycarousel').jcarousel();
	});

	function showonlyone(thechosenone) {
     $('div[name|="newboxes"]').each(function(index) {
          if ($(this).attr("id") == thechosenone) {
               $(this).show(200);
          }
          else {
               $(this).hide(600);
          }
     });
	} 
</script>
<style type="text/css">
		* {
			padding: 0; 
			margin: 0; 
		}
		body {
			font: 11px Tahoma;
			background-color: #F7F7E9;
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

		.mGrid { width: 100%; background-color: #fff; margin: 5px 0 10px 0; border: solid 1px #525252; border-collapse:collapse; }
		.mGrid td { padding: 2px; border: solid 1px #c1c1c1; color: #717171; }
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

		#umlist{position:absolute;left:20px;top:100px;}
		#umlist li{margin:0;padding:0;list-style:none;}
		#umlist li, #umlist a{height:36px;display:block;}

		#um{left:0px;width:35px;}
		#um{background:url(/images/navigation/user_mgmt.png) 36px 0px;}
		#um a:hover{background: url(/images/navigation/user_mgmt.png) 0px 0px;}
</style>
<!--[if !IE 7]>
	<style type="text/css">
		#wrap {display:table;height:100%}
	</style>
<![endif]-->
</head>
<body>
	<ul id="umlist">
		<li id="um"><a href="UserMgmt.aspx"></a></li>
	</ul>
<div id="wrap">

	<div id="main">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager runat="Server" EnableScriptGlobalization="true" EnableScriptLocalization="true" ID="ScriptManager1" />
<DIV ID="block_top">
	<DIV CLASS="block_top_head">
		<table cellspacing="0" cellpadding="0" border="0" width="99%">
			<tr>
				<td align="left" width="320"><IMG SRC="../../../images/emunching_logo_AP_mod_sm.png" WIDTH="300" HEIGHT="63" BORDER="0" ALT=""></td>
				<td align="left"><a class="navlinkunselected" href="/" >Admin Control Panel</a></td>
				<td align="right"><asp:LoginStatus ID="LoginStatus1" cssclass="Logout" LogoutAction="Redirect" LogoutPageUrl="/Restaurants/Default.aspx" runat="server" /></td>
			</tr>
		</table>
	</div>
</DIV>
<div id="block_top_under">
	<DIV CLASS="block_top_under_head">Welcome Back, <font color="#16a7e7"><asp:LoginName ID="LoginName1" runat="server" /></font>!</div>
</div>
<br><br>
<center>
<div id="wrap">
  <a href="default.aspx"><IMG SRC="/images/navigation/header-bg.png"  class="jcarousel-skin-tango" WIDTH="1000" HEIGHT="52" BORDER="0" ALT=""></a>
  <ul id="mycarousel" class="jcarousel-skin-tango">
    <li id="a"><a href="javascript:showonlyone('newboxes1');"><img src="~/images/navigation/home_off.png" width="117" height="150" alt="" /></a></li>
	<li id="b"><a href="javascript:showonlyone('newboxes2');"><img src="~/images/navigation/menu_off.png" width="117" height="150" alt="" /></a></li>
	<li id="c"><a href="javascript:showonlyone('newboxes3');"><img src="~/images/navigation/orders_off.png" width="117" height="150" alt="" /></a></li>
	<li id="d"><a href="javascript:showonlyone('newboxes4');"><img src="~/images/navigation/reservation_off.png" width="117" height="150" alt="" /></a></li>
	<li id="e"><a href="javascript:showonlyone('newboxes5');"><img src="~/images/navigation/about_off.png" width="117" height="150" alt="" /></a></li>
	<li id="f"><a href="javascript:showonlyone('newboxes6');"><img src="~/images/navigation/settings_off.png" width="117" height="150" alt="" /></a></li>
	<li id="g"><a href="javascript:showonlyone('newboxes7');"><img src="~/images/navigation/uploads_off.png" width="117" height="150" alt="" /></a></li>
	<li id="h"><a href="javascript:showonlyone('newboxes8');"><img src="~/images/navigation/messages_off.png" width="117" height="150" alt="" /></a></li>
	<li id="i"><a href="javascript:showonlyone('newboxes9');"><img src="~/images/navigation/reports_off.png" width="117" height="150" alt="" /></a></li>
	<li id="j"><a href="javascript:showonlyone('newboxes10');"><img src="~/images/navigation/events_off.png" width="117" height="150" alt="" /></a></li>
	<li id="k"><a href="javascript:showonlyone('newboxes11');"><img src="~/images/navigation/deals_off.png" width="117" height="150" alt="" /></a></li>
	<li id="l"><a href="javascript:showonlyone('newboxes12');"><img src="~/images/navigation/reviews_off.png" width="117" height="150" alt="" /></a></li>
	<li id="m"><a href="javascript:showonlyone('newboxes13');"><img src="~/images/navigation/support_off.png" width="117" height="150" alt="" /></a></li>
  </ul>
  <table style="border:1px solid black;width:1000px;">
   <tr>
      <td>
         <div name="newboxes" id="newboxes1" style="border: 1px solid black; background-color: #CCCCCC; display: block;padding: 5px;">
			<center>
			<asp:label runat="server" id="msg" /><br>
			If others email addresses should be copied on all new user registrations, please enter the email addresses below. Multiple email addresses should be seperated by a semi-colon (;)<br>
			<asp:TextBox ID="UserRegCCAddress" runat="server" cssclass="input" size="39"></asp:TextBox>&nbsp;&nbsp;&nbsp;<asp:Button	id="btnSubmit2" Text="Save" Runat="server" cssclass="input" onclick="SubmitButton2_Click" />
			<br>
			<asp:GridView ID="GridView1" 
						  runat="server"
						  AutoGenerateColumns="False" 
						  DataKeyNames="ID"
						  DataSourceID="dsUsers" 
						  ShowFooter="false" 
						  GridLines="None"
						  AllowPaging="True" 
						  AllowSorting="True" 
						  CssClass="mGrid"
						  PagerStyle-CssClass="pgr"
						  AlternatingRowStyle-CssClass="alt"
						  OnRowCommand="GridView1_RowCommand"
						  >
				<Columns>
			   
					<asp:CommandField ShowEditButton="True"/> 
					<asp:TemplateField>
						  <ItemTemplate>
							<asp:Button ID="btnDel" 
										runat="server" 
										Text="Deactivate?"
										cssclass="input"
										CommandName="Delete" 
										OnClientClick="return confirm('Are you sure you want to delete the user?');" />
							<asp:Button ID="ResPwd" CommandName="ResPwd" runat="server" cssclass="input" CommandArgument='<%# Bind("ID")%>' Text="Reset Pwd?"></asp:Button>
						  </ItemTemplate>
					</asp:TemplateField>

					<asp:TemplateField HeaderText="ID" SortExpression="ID" itemstyle-width="100px" itemstyle-wrap="true">
						<EditItemTemplate>
							<asp:TextBox ID="ID" runat="server" cssclass="input" Size="25" Text='<%# Bind("ID") %>'></asp:TextBox>
						</EditItemTemplate>
						<ItemTemplate>
							<asp:Label ID="Label1" runat="server" Text='<%# Bind("ID") %>'></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Location" SortExpression="LocationName" itemstyle-width="100px" itemstyle-wrap="true">
						<EditItemTemplate>
							<asp:DropDownList ID="RestaurantLocaID"
											  cssclass="input"
											  Runat="server"
											  DataSourceID="AvailLocations" 
											  DataTextField="LName" 
											  DataValueField="LocaID"
											  SelectedValue='<%# Bind("RestaurantLocaID") %>'>
							</asp:DropDownList>
						</EditItemTemplate>
						<ItemTemplate>
							<asp:Label ID="Label2" runat="server" Text='<%# Bind("LocationName") %>'></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					
					<asp:TemplateField HeaderText="First Name" SortExpression="FirstName" itemstyle-wrap="true">
						<EditItemTemplate>
							<asp:TextBox ID="FirstName" runat="server" cssclass="input" Size="5" Text='<%# Bind("FirstName") %>'></asp:TextBox>
						</EditItemTemplate>
						<ItemTemplate>
							<asp:Label ID="Label3" runat="server" Text='<%# Bind("FirstName") %>'></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>

					<asp:TemplateField HeaderText="Last Name" SortExpression="LastName" itemstyle-wrap="true">
						<EditItemTemplate>
							<asp:TextBox ID="LastName" runat="server" cssclass="input" Size="5" Text='<%# Bind("LastName") %>'></asp:TextBox>
						</EditItemTemplate>
						<ItemTemplate>
							<asp:Label ID="Label4" runat="server" Text='<%# Bind("LastName") %>'></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>

					<asp:TemplateField HeaderText="E-Mail" SortExpression="EMail" itemstyle-wrap="true">
						<EditItemTemplate>
							<asp:TextBox ID="EMail" runat="server" cssclass="input" Size="25" Text='<%# Bind("EMail") %>'></asp:TextBox>
						</EditItemTemplate>
						<ItemTemplate>
							<asp:Label ID="Label6" runat="server" Text='<%# Bind("EMail") %>'></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>

					<asp:TemplateField HeaderText="Phone" SortExpression="Phone" itemstyle-wrap="true">
						<EditItemTemplate>
							<asp:TextBox ID="Phone" runat="server" cssclass="input" Size="5" Text='<%# Bind("Phone") %>'></asp:TextBox>
						</EditItemTemplate>
						<ItemTemplate>
							<asp:Label ID="Label7" runat="server" Text='<%# Bind("Phone") %>'></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>

					<asp:TemplateField HeaderText="Last Login" SortExpression="LastLogin" itemstyle-width="120px" itemstyle-wrap="true">
						<ItemTemplate>
							<asp:Label ID="Label9" runat="server" Text='<%# Bind("LastLogin") %>'></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>

					<asp:TemplateField HeaderText="Active?" SortExpression="Active" itemstyle-wrap="true">
						<EditItemTemplate>
							<asp:DropDownList ID="Active" 
											  runat="server" 
											  cssclass="input"
											  SelectedValue='<%# Bind("Active", "{0}") %>'>
								<asp:listitem value="0" text="0" />
								<asp:listitem value="1" text="1" />
							</asp:DropDownList>
						</EditItemTemplate>
						<ItemTemplate>
							<asp:Label ID="Label10" runat="server" Text='<%# Bind("Active") %>'></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>



				</Columns>
			</asp:GridView>
			</center>
			<asp:SqlDataSource ID="dsUsers" 
							   runat="server" 
							   ProviderName="System.Data.SqlClient" 
							   SelectCommand="p_gv_SelectRestaurantMobileAppUsers @RestID"
							   DeleteCommand="p_gv_ArchiveUser @ID"
							   UpdateCommand="p_gv_UpdateMobileAppUser @ID,@RestaurantLocaID,@FirstName,@LastName,@Email,@Phone,@Active"
							   >
				<SelectParameters>
					<asp:sessionparameter name="RestID" sessionfield="RestID" /> 
				</SelectParameters>
				<DeleteParameters>
					<asp:Parameter Name="ID" />
				</DeleteParameters>
				<UpdateParameters>
					<asp:Parameter Name="Active" Type="Int32"/>
					<asp:Parameter Name="Phone" Type="String" />
					<asp:Parameter Name="Email" Type="String" />
					<asp:Parameter Name="LastName" Type="String" />
					<asp:Parameter Name="Firstname" Type="String" />
					<asp:Parameter Name="RestaurantLocaID" Type="Int32" />
					<asp:Parameter Name="ID" Type="String" />
				</UpdateParameters>
			</asp:SqlDataSource>
		 </div>
		 <div name="newboxes" id="newboxes2" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
		 <h1>Menus</h1>
			<iframe frameborder="0" src="menus-landing.aspx" width="990px" height="700px"></iframe>
		 </div>
		 <div name="newboxes" id="newboxes3" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Orders</h1>
			<iframe frameborder="0" src="order.aspx" width="990px" height="700px"></iframe>
		 </div>
         <div name="newboxes" id="newboxes4" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Reservations</h1>
			<iframe frameborder="0" src="resv.aspx" width="990px" height="700px"></iframe>
		 </div>
		 <div name="newboxes" id="newboxes5" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>About</h1>
			<iframe frameborder="0" src="about.aspx" width="990px" height="700px"></iframe>
		 </div>
         <div name="newboxes" id="newboxes6" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Console Settings/Configure Custom App</h1>
			<iframe frameborder="0" name="ThemeiFrame" src="Settings.aspx?Atab=0" width="890px" height="1050px"></iframe>
		 </div>
		 <div name="newboxes" id="newboxes7" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Uploads</h1>
			<iframe frameborder="0" src="Uploads.aspx" width="990px" height="700"></iframe>
		 </div>
         <div name="newboxes" id="newboxes8" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Email Templates</h1>
			<iframe frameborder="0" src="msg2.aspx" width="990px" height="700px"></iframe>
		 </div>
         <div name="newboxes" id="newboxes9" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Reports</h1>
		 </div>
		 <div name="newboxes" id="newboxes10" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Events</h1>
			<iframe frameborder="0" src="events.aspx" width="990px" height="700px"></iframe>
		 </div>
         <div name="newboxes" id="newboxes11" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Deals</h1>
			<iframe frameborder="0" src="deals.aspx" width="990px" height="700px"></iframe>
		 </div>
		 <div name="newboxes" id="newboxes12" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Reviews</h1>
			<iframe frameborder="0" src="reviews.aspx" width="990px" height="700px"></iframe>
		 </div>
         <div name="newboxes" id="newboxes13" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Support</h1>
			<iframe frameborder="0" src="support.aspx" width="990px" height="700px"></iframe>
		 </div>
      </td>
   </tr>
  </table> 

</div>
</div>

</div>
<div id="footer" align="center">
	<b>Copyright Indavest&copy;2011. All Rights Reserved.</b>
</div>
</center>
</form>
</body>
</html>




	