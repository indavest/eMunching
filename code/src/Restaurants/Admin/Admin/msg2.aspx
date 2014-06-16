<%@ Page Language="VB" debug="true"%>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="FredCK.FCKeditorV2" Namespace="FredCK.FCKeditorV2" TagPrefix="FCKEditorV2" %>
<script runat="server">
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        SqlDataSource1.ConnectionString = connectionObject("connectionStringApp")
        SqlDataSource2.ConnectionString = connectionObject("connectionStringApp")
        SqlDataSource3.ConnectionString = connectionObject("connectionStringApp")
        SqlDataSource4.ConnectionString = connectionObject("connectionStringApp")
        SqlDataSource5.ConnectionString = connectionObject("connectionStringApp")
        SqlDataSource6.ConnectionString = connectionObject("connectionStringApp")
        SqlDataSource7.ConnectionString = connectionObject("connectionStringApp")
        SqlDataSource8.ConnectionString = connectionObject("connectionStringApp")
        SqlDataSource9.ConnectionString = connectionObject("connectionStringApp")
    End Sub
    
	Public Function ConvertFormattedString(FStr As String)
		Dim ProcessedHTML As String
		'ProcessedHTML = Server.HtmlEncode(FStr)
		ProcessedHTML = Server.HtmlDecode(FStr)
		Return ProcessedHTML
	End Function

	Private Sub GridView1_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles GridView1.RowUpdating
		Dim row As GridViewRow = Me.GridView1.Rows(e.RowIndex)
		Dim ftxtDescription As FredCK.FCKeditorV2.FCKeditor = CType(row.FindControl("MsgBody"), FredCK.FCKeditorV2.FCKeditor)
		Me.SqlDataSource1.UpdateParameters("MsgBody").DefaultValue = ftxtDescription.Value
		Me.SqlDataSource1.Update()
		Me.GridView1.DataBind()
	End Sub

	Private Sub GridView2_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles GridView2.RowUpdating
		Dim row As GridViewRow = Me.GridView2.Rows(e.RowIndex)
		Dim ftxtDescription As FredCK.FCKeditorV2.FCKeditor = CType(row.FindControl("MsgBody"), FredCK.FCKeditorV2.FCKeditor)
		Me.SqlDataSource2.UpdateParameters("MsgBody").DefaultValue = ftxtDescription.Value
		Me.SqlDataSource2.Update()
		Me.GridView2.DataBind()
	End Sub

	Private Sub GridView3_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles GridView3.RowUpdating
		Dim row As GridViewRow = Me.GridView3.Rows(e.RowIndex)
		Dim ftxtDescription As FredCK.FCKeditorV2.FCKeditor = CType(row.FindControl("MsgBody"), FredCK.FCKeditorV2.FCKeditor)
		Me.SqlDataSource3.UpdateParameters("MsgBody").DefaultValue = ftxtDescription.Value
		Me.SqlDataSource3.Update()
		Me.GridView3.DataBind()
	End Sub

	Private Sub GridView4_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles GridView4.RowUpdating
		Dim row As GridViewRow = Me.GridView4.Rows(e.RowIndex)
		Dim ftxtDescription As FredCK.FCKeditorV2.FCKeditor = CType(row.FindControl("MsgBody"), FredCK.FCKeditorV2.FCKeditor)
		Me.SqlDataSource4.UpdateParameters("MsgBody").DefaultValue = ftxtDescription.Value
		Me.SqlDataSource4.Update()
		Me.GridView4.DataBind()
	End Sub

	Private Sub GridView5_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles GridView5.RowUpdating
		Dim row As GridViewRow = Me.GridView5.Rows(e.RowIndex)
		Dim ftxtDescription As FredCK.FCKeditorV2.FCKeditor = CType(row.FindControl("MsgBody"), FredCK.FCKeditorV2.FCKeditor)
		Me.SqlDataSource5.UpdateParameters("MsgBody").DefaultValue = ftxtDescription.Value
		Me.SqlDataSource5.Update()
		Me.GridView5.DataBind()
	End Sub

	Private Sub GridView6_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles GridView6.RowUpdating
		Dim row As GridViewRow = Me.GridView6.Rows(e.RowIndex)
		Dim ftxtDescription As FredCK.FCKeditorV2.FCKeditor = CType(row.FindControl("MsgBody"), FredCK.FCKeditorV2.FCKeditor)
		Me.SqlDataSource6.UpdateParameters("MsgBody").DefaultValue = ftxtDescription.Value
		Me.SqlDataSource6.Update()
		Me.GridView6.DataBind()
	End Sub

	Private Sub GridView7_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles GridView7.RowUpdating
		Dim row As GridViewRow = Me.GridView7.Rows(e.RowIndex)
		Dim ftxtDescription As FredCK.FCKeditorV2.FCKeditor = CType(row.FindControl("MsgBody"), FredCK.FCKeditorV2.FCKeditor)
		Me.SqlDataSource7.UpdateParameters("MsgBody").DefaultValue = ftxtDescription.Value
		Me.SqlDataSource7.Update()
		Me.GridView7.DataBind()
	End Sub

	Private Sub GridView8_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles GridView8.RowUpdating
		Dim row As GridViewRow = Me.GridView8.Rows(e.RowIndex)
		Dim ftxtDescription As FredCK.FCKeditorV2.FCKeditor = CType(row.FindControl("MsgBody"), FredCK.FCKeditorV2.FCKeditor)
		Me.SqlDataSource8.UpdateParameters("MsgBody").DefaultValue = ftxtDescription.Value
		Me.SqlDataSource8.Update()
		Me.GridView8.DataBind()
	End Sub

	Private Sub GridView9_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles GridView9.RowUpdating
		Dim row As GridViewRow = Me.GridView9.Rows(e.RowIndex)
		Dim ftxtDescription As FredCK.FCKeditorV2.FCKeditor = CType(row.FindControl("MsgBody"), FredCK.FCKeditorV2.FCKeditor)
		Me.SqlDataSource9.UpdateParameters("MsgBody").DefaultValue = ftxtDescription.Value
		Me.SqlDataSource9.Update()
		Me.GridView9.DataBind()
	End Sub
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us">
<head runat="server">
<title>Admin Control Panel</title>
<style>
body{background-color: #cccccc; margin: 0px; padding: 0px;}
#wrapper{background: #cccccc; -moz-box-shadow: 0px 0px 10px #666; -webkit-box-shadow: 0px 0px 10px #666; margin: 0 auto; min-height: 600px;}
h1 {text-align: center; font-size: 42px; font-family: Georgia, "Times New Roman", Times, serif; color: #333333; margin: 0px; padding: 0px;}
</style>
<script type="text/javascript" src="/js/carousel/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/js/verticaltabs.pack.js"></script>
<link rel="stylesheet" href="/themes/verticaltabs.css" />
<link rel="stylesheet" type="text/css" href="/js/carousel/skin2.css" />
<link rel="stylesheet" type="text/css" href="/js/carousel/skin1.css" />
<script type="text/javascript">
	$(document).ready(function() {

		$("#textExample").verticaltabs({speed: 500,slideShow: false,activeIndex:0});

		//Default Action
		$(".tab_content").hide(); //Hide all content
		$("ul.tabs li:first").addClass("active").show(); //Activate first tab
		$(".tab_content:first").show(); //Show first tab content
		
		//On Click Event
		$("ul.tabs li").click(function() {
			$("ul.tabs li").removeClass("active"); //Remove any "active" class
			$(this).addClass("active"); //Add "active" class to selected tab
			$(".tab_content").hide(); //Hide all tab content
			var activeTab = $(this).find("a").attr("href"); //Find the rel attribute value to identify the active tab + content
			$(activeTab).fadeIn(); //Fade in the active content
			return false;
		});

	});

</script>

	<style type="text/css">
		* {
			padding: 0; 
			margin: 0; 
		}
		body {
			font: 11px Tahoma;
			background-color: #CCCCCC /*#F7F7E9*/;
		}
		h1 {
			font: bold 32px Times;
			color: #666;
			text-align: center;
			/*padding: 20px 0;    */
		}
		#container {
			/*width: 750px;*/
			margin: 10px auto;
		}

		#wrapper {
			/*width: 700px;*/
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
		.input {font: 11px Tahoma;}
		.lblMoney {text-align: right;}
	</style>
</head>
<body>
<form runat="server">
<ajaxToolkit:ToolkitScriptManager runat="Server" EnableScriptGlobalization="true"  EnableScriptLocalization="true" ID="ScriptManager1" />
<div id="wrapper">
   <p align="justify">These email templates represent the text that will be in the message body of the various communications that go out to the eMunching users whenever they take certain actions from within the app. In order to modify the email templates, change the text in the editor that corresponds to the action and click the button below that states 'Submit Content.'</p>
   <p align="justify">In addition to customizing the text of the message, you can include system information in the body of the text. For example, if you would like for the user to see their username in the message body, you would include this in the text: [USERID]. A complete list of the allowed placeholders are described in each message body section.</p>
	<div class="verticalslider" id="textExample">
        <ul class="verticalslider_tabs">
            <li><a href="#">New User</a></li>
            <li><a href="#">Reservation - Accepted</a></li>
            <li><a href="#">Reservation - Declined</a></li>
			<li><a href="#">Reservation - Cancellation</a></li> 
            <li><a href="#">Order - Pending</a></li>  
			<li><a href="#">Order - Acknowledged</a></li>  
			<li><a href="#">Order - Cancellation</a></li> 
			<li><a href="#">User Profile - Forgotten Password</a></li>  
			<li><a href="#">User Profile - Information Updated</a></li>  
        </ul>
        <ul class="verticalslider_contents">
            <li>
            <h2>New User</h2>
			<p>
				User ID - [USERID]<br>
				Password - [PWD]<br>
				Authentication Code - [AUTHCODE]
			</p>
            <p>
			
				<asp:GridView ID="GridView1" 
							  runat="server"
							  AutoGenerateColumns="False" 
							  DataKeyNames="ID"
							  DataSourceID="SqlDataSource1" 
							  ShowFooter="false" 
							  GridLines="None"
							  CssClass="mGrid"
							  PagerStyle-CssClass="pgr"
							  AlternatingRowStyle-CssClass="alt"
							  >
					<Columns>
				   
						<asp:CommandField ShowEditButton="True"/>
						<asp:TemplateField>
							<EditItemTemplate>
								<FCKEditorV2:FCKEditor ID="MsgBody" runat="server" basePath="fckeditor/" ToolbarSet="Basic" Height="300" Width="680" Value='<%# ConvertFormattedString(Eval("MsgBody"))%>' />
							</EditItemTemplate>
							<ItemTemplate>
								<asp:label runat="server" ID="NewUserLbl" cssclass="input" Text='<%# Bind("MsgBody")%>' />
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
				</asp:GridView>
				<asp:SqlDataSource ID="SqlDataSource1" 
								   runat="server" 
							       SelectCommand="p_SelectEmailTemplate @RestID,'NewUser'"
								   UpdateCommand="p_UpdateEmailTemplate @ID,'NewUser',@MsgBody">
					<SelectParameters>
					  <asp:sessionparameter name="RestID" sessionfield="RestID" /> 
					</SelectParameters>
					<UpdateParameters>
						<asp:parameter name="ID" type="String" />
						<asp:parameter name="MsgBody" type="String" />
					</UpdateParameters>
				</asp:SqlDataSource>
				
			</p></li>
            <li>
            <h2>Reservation - Accepted</h2>
            <p>
				Requested Time - [TIMESLOT]<br>
			</p>
			<p>
				<asp:GridView ID="GridView2" 
							  runat="server"
							  AutoGenerateColumns="False" 
							  DataKeyNames="ID"
							  DataSourceID="SqlDataSource2" 
							  ShowFooter="false" 
							  GridLines="None"
							  CssClass="mGrid"
							  PagerStyle-CssClass="pgr"
							  AlternatingRowStyle-CssClass="alt">
					<Columns>
				   
						<asp:CommandField ShowEditButton="True" ItemStyle-HorizontalAlign="Center"/> 
						<asp:TemplateField ItemStyle-HorizontalAlign="Center">
							<EditItemTemplate>
								<asp:HiddenField runat="server" ID="hidLastTab" Value="2" />
								<FCKEditorV2:FCKEditor ID="MsgBody" runat="server" basePath="fckeditor/" ToolbarSet="Basic" Height="300" Width="680" Value='<%# ConvertFormattedString(Eval("MsgBody"))%>' />
							</EditItemTemplate>
							<ItemTemplate>
								<asp:label runat="server" ID="NewUserLbl2" cssclass="input" Text='<%# Bind("MsgBody")%>' />
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
				</asp:GridView>
				<asp:SqlDataSource ID="SqlDataSource2" 
								   runat="server" 
							       SelectCommand="p_SelectEmailTemplate @RestID,'ResvAccept'"
								   UpdateCommand="p_UpdateEmailTemplate @ID,'ResvAccept',@MsgBody">
					<SelectParameters>
					  <asp:sessionparameter name="RestID" sessionfield="RestID" /> 
					</SelectParameters>
					<UpdateParameters>
						<asp:parameter name="ID" type="Int32" />
						<asp:parameter name="MsgBody" type="String" />
					</UpdateParameters>
				</asp:SqlDataSource></p></li>
            <li>
            <h2>Reservation - Declined</h2>
			<p>
				Requested Time - [TIMESLOT]<br>
			</p>
            <p><asp:GridView ID="GridView3" 
							  runat="server"
							  AutoGenerateColumns="False" 
							  DataKeyNames="ID"
							  DataSourceID="SqlDataSource3" 
							  ShowFooter="false" 
							  GridLines="None"
							  CssClass="mGrid"
							  PagerStyle-CssClass="pgr"
							  AlternatingRowStyle-CssClass="alt">
					<Columns>
				   
						<asp:CommandField ShowEditButton="True"/> 
						<asp:TemplateField>
							<EditItemTemplate>
								<FCKEditorV2:FCKEditor ID="MsgBody" runat="server" basePath="fckeditor/" ToolbarSet="Basic" Height="300" Width="680" Value='<%# ConvertFormattedString(Eval("MsgBody"))%>' />
							</EditItemTemplate>
							<ItemTemplate>
								<asp:label runat="server" ID="NewUserLbl3" cssclass="input" Text='<%# Bind("MsgBody")%>' />
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
				</asp:GridView>
				<asp:SqlDataSource ID="SqlDataSource3" 
								   runat="server" 
							       SelectCommand="p_SelectEmailTemplate @RestID,'ResvDecln'"
								   UpdateCommand="p_UpdateEmailTemplate @ID,'ResvDecln',@MsgBody">
					<SelectParameters>
					  <asp:sessionparameter name="RestID" sessionfield="RestID" /> 
					</SelectParameters>
					<UpdateParameters>
						<asp:parameter name="ID" type="Int32" />
						<asp:parameter name="MsgBody" type="String" />
					</UpdateParameters>
				</asp:SqlDataSource></p></li>
            <li>
            <h2>Reservation - Cancellation</h2>
			<p>
				Requested Time - [TIMESLOT]<br>
			</p>
            <p><asp:GridView ID="GridView4" 
							  runat="server"
							  AutoGenerateColumns="False" 
							  DataKeyNames="ID"
							  DataSourceID="SqlDataSource4" 
							  ShowFooter="false" 
							  GridLines="None"
							  CssClass="mGrid"
							  PagerStyle-CssClass="pgr"
							  AlternatingRowStyle-CssClass="alt">
					<Columns>
				   
						<asp:CommandField ShowEditButton="True"/> 
						<asp:TemplateField>
							<EditItemTemplate>
								<FCKEditorV2:FCKEditor ID="MsgBody" runat="server" basePath="fckeditor/" ToolbarSet="Basic" Height="300" Width="680" Value='<%# ConvertFormattedString(Eval("MsgBody"))%>' />
							</EditItemTemplate>
							<ItemTemplate>
								<asp:label runat="server" ID="NewUserLbl4" cssclass="input" Text='<%# Bind("MsgBody")%>' />
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
				</asp:GridView>
				<asp:SqlDataSource ID="SqlDataSource4" 
								   runat="server" 
							       SelectCommand="p_SelectEmailTemplate @RestID,'ResvCancl'"
								   UpdateCommand="p_UpdateEmailTemplate @ID,'ResvCancl',@MsgBody">
					<SelectParameters>
					  <asp:sessionparameter name="RestID" sessionfield="RestID" /> 
					</SelectParameters>
					<UpdateParameters>
						<asp:parameter name="ID" type="Int32" />
						<asp:parameter name="MsgBody" type="String" />
					</UpdateParameters>
				</asp:SqlDataSource></p></li>    
			<li>
			<h2>Order - Pending</h2>
			<p>
				Order Name - [ORDERNAME]<br>
			</p>
            <p><asp:GridView ID="GridView5" 
							  runat="server"
							  AutoGenerateColumns="False" 
							  DataKeyNames="ID"
							  DataSourceID="SqlDataSource5" 
							  ShowFooter="false" 
							  GridLines="None"
							  CssClass="mGrid"
							  PagerStyle-CssClass="pgr"
							  AlternatingRowStyle-CssClass="alt">
					<Columns>
				   
						<asp:CommandField ShowEditButton="True"/> 
						<asp:TemplateField>
							<EditItemTemplate>
								<FCKEditorV2:FCKEditor ID="MsgBody" runat="server" basePath="fckeditor/" ToolbarSet="Basic" Height="300" Width="680" Value='<%# ConvertFormattedString(Eval("MsgBody"))%>' />
							</EditItemTemplate>
							<ItemTemplate>
								<asp:label runat="server" ID="NewUserLbl5" cssclass="input" Text='<%# Bind("MsgBody")%>' />
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
				</asp:GridView>
				<asp:SqlDataSource ID="SqlDataSource5" 
								   runat="server" 
							       SelectCommand="p_SelectEmailTemplate @RestID,'OrderPending'"
								   UpdateCommand="p_UpdateEmailTemplate @ID,'OrderPending',@MsgBody">
					<SelectParameters>
					  <asp:sessionparameter name="RestID" sessionfield="RestID" /> 
					</SelectParameters>
					<UpdateParameters>
						<asp:parameter name="ID" type="Int32" />
						<asp:parameter name="MsgBody" type="String" />
					</UpdateParameters>
				</asp:SqlDataSource></p></li>   
			<li>
			<h2>Order - Acknowledged</h2>
            <p><asp:GridView ID="GridView6" 
							  runat="server"
							  AutoGenerateColumns="False" 
							  DataKeyNames="ID"
							  DataSourceID="SqlDataSource6" 
							  ShowFooter="false" 
							  GridLines="None"
							  CssClass="mGrid"
							  PagerStyle-CssClass="pgr"
							  AlternatingRowStyle-CssClass="alt">
					<Columns>
				   
						<asp:CommandField ShowEditButton="True"/> 
						<asp:TemplateField>
							<EditItemTemplate>
								<FCKEditorV2:FCKEditor ID="MsgBody" runat="server" basePath="fckeditor/" ToolbarSet="Basic" Height="300" Width="680" Value='<%# ConvertFormattedString(Eval("MsgBody"))%>' />
							</EditItemTemplate>
							<ItemTemplate>
								<asp:label runat="server" ID="NewUserLbl6" cssclass="input" Text='<%# Bind("MsgBody")%>' />
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
				</asp:GridView>
				<asp:SqlDataSource ID="SqlDataSource6" 
								   runat="server" 
							       SelectCommand="p_SelectEmailTemplate @RestID,'OrderAck'"
								   UpdateCommand="p_UpdateEmailTemplate @ID,'OrderAck',@MsgBody">
					<SelectParameters>
					  <asp:sessionparameter name="RestID" sessionfield="RestID" /> 
					</SelectParameters>
					<UpdateParameters>
						<asp:parameter name="ID" type="Int32" />
						<asp:parameter name="MsgBody" type="String" />
					</UpdateParameters>
				</asp:SqlDataSource></p></li>   
			<li>
			<h2>Order - Cancellation</h2>
            <p><asp:GridView ID="GridView7" 
							  runat="server"
							  AutoGenerateColumns="False" 
							  DataKeyNames="ID"
							  DataSourceID="SqlDataSource7" 
							  ShowFooter="false" 
							  GridLines="None"
							  CssClass="mGrid"
							  PagerStyle-CssClass="pgr"
							  AlternatingRowStyle-CssClass="alt">
					<Columns>
				   
						<asp:CommandField ShowEditButton="True"/> 
						<asp:TemplateField>
							<EditItemTemplate>
								<FCKEditorV2:FCKEditor ID="MsgBody" runat="server" basePath="fckeditor/" ToolbarSet="Basic" Height="300" Width="680" Value='<%# ConvertFormattedString(Eval("MsgBody"))%>' />
							</EditItemTemplate>
							<ItemTemplate>
								<asp:label runat="server" ID="NewUserLbl7" cssclass="input" Text='<%# Bind("MsgBody")%>' />
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
				</asp:GridView>
				<asp:SqlDataSource ID="SqlDataSource7" 
								   runat="server" 
							       SelectCommand="p_SelectEmailTemplate @RestID,'OrderCancl'"
								   UpdateCommand="p_UpdateEmailTemplate @ID,'OrderCancl',@MsgBody">
					<SelectParameters>
					  <asp:sessionparameter name="RestID" sessionfield="RestID" /> 
					</SelectParameters>
					<UpdateParameters>
						<asp:parameter name="ID" type="Int32" />
						<asp:parameter name="MsgBody" type="String" />
					</UpdateParameters>
				</asp:SqlDataSource></p></li>   
			<li>
			<h2>User Profile - Forgotten Password</h2>
            <p><asp:GridView ID="GridView8" 
							  runat="server"
							  AutoGenerateColumns="False" 
							  DataKeyNames="ID"
							  DataSourceID="SqlDataSource8" 
							  ShowFooter="false" 
							  GridLines="None"
							  CssClass="mGrid"
							  PagerStyle-CssClass="pgr"
							  AlternatingRowStyle-CssClass="alt">
					<Columns>
				   
						<asp:CommandField ShowEditButton="True"/> 
						<asp:TemplateField>
							<EditItemTemplate>
								<FCKEditorV2:FCKEditor ID="MsgBody" runat="server" basePath="fckeditor/" ToolbarSet="Basic" Height="300" Width="680" Value='<%# ConvertFormattedString(Eval("MsgBody"))%>' />
							</EditItemTemplate>
							<ItemTemplate>
								<asp:label runat="server" ID="NewUserLbl8" cssclass="input" Text='<%# Bind("MsgBody")%>' />
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
				</asp:GridView>
				<asp:SqlDataSource ID="SqlDataSource8" 
								   runat="server" 
							       SelectCommand="p_SelectEmailTemplate @RestID,'UserFPwd'"
								   UpdateCommand="p_UpdateEmailTemplate @ID,'UserFPwd',@MsgBody">
					<SelectParameters>
					  <asp:sessionparameter name="RestID" sessionfield="RestID" /> 
					</SelectParameters>
					<UpdateParameters>
						<asp:parameter name="ID" type="Int32" />
						<asp:parameter name="MsgBody" type="String" />
					</UpdateParameters>
				</asp:SqlDataSource></p></li>   
			<li>
			<h2>User Profile - Information Updated</h2>
            <p><asp:GridView ID="GridView9" 
							  runat="server"
							  AutoGenerateColumns="False" 
							  DataKeyNames="ID"
							  DataSourceID="SqlDataSource9" 
							  ShowFooter="false" 
							  GridLines="None"
							  CssClass="mGrid"
							  PagerStyle-CssClass="pgr"
							  AlternatingRowStyle-CssClass="alt">
					<Columns>
				   
						<asp:CommandField ShowEditButton="True"/> 
						<asp:TemplateField>
							<EditItemTemplate>
								<FCKEditorV2:FCKEditor ID="MsgBody" runat="server" basePath="fckeditor/" ToolbarSet="Basic" Height="300" Width="680" Value='<%# ConvertFormattedString(Eval("MsgBody"))%>' />
							</EditItemTemplate>
							<ItemTemplate>
								<asp:label runat="server" ID="NewUserLbl9" cssclass="input" Text='<%# Bind("MsgBody")%>' />
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
				</asp:GridView>
				<asp:SqlDataSource ID="SqlDataSource9" 
								   runat="server" 
							       SelectCommand="p_SelectEmailTemplate @RestID,'UserProfUp'"
								   UpdateCommand="p_UpdateEmailTemplate @ID,'UserProfUp',@MsgBody">
					<SelectParameters>
					  <asp:sessionparameter name="RestID" sessionfield="RestID" /> 
					</SelectParameters>
					<UpdateParameters>
						<asp:parameter name="ID" type="Int32" />
						<asp:parameter name="MsgBody" type="String" />
					</UpdateParameters>
				</asp:SqlDataSource></p></p></li> 
			
			<li>
        </ul>
    </div> 
</div>
</form>
</body>