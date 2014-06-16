<%@ Page Language="VB" debug="true"%>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor" TagPrefix="HTMLEditor" %>
<script runat="server">
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        SqlDataSource1.ConnectionString = connectionObject("connectionStringApp")
    End Sub
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us">
<head runat="server">
<title>Admin Control Panel</title>
<style>
		body{
			background: #cccccc; 
			margin: 0px; 
			padding: 0px;
		}

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

		#wrapper {
			width: 700px;
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
	<asp:GridView ID="GridView1" 
				  runat="server"
				  AutoGenerateColumns="False" 
				  DataKeyNames="ID"
				  DataSourceID="SqlDataSource1" 
				  ShowFooter="false" 
				  GridLines="None"
				  CssClass="mGrid"
				  PagerStyle-CssClass="pgr"
				  AlternatingRowStyle-CssClass="alt">
		<Columns>   
			<asp:CommandField ShowEditButton="True"/>
			<asp:TemplateField>
				<ItemTemplate>
					<asp:label runat="server" ID="ActionDescLBL" cssclass="input" Text='<%# Bind("ActionDesc")%>' />
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField>
				<EditItemTemplate>
					<asp:label runat="server" ID="mID" Text='<%# Bind("ID")%>' />
					<asp:textbox runat="server" ID="Action" cssclass="input" Text='<%# Bind("ActionName")%>' /><br>
					<asp:textbox runat="server" ID="MsgBody" cssclass="input" Rows="10" Columns="75" Text='<%# Bind("MsgBody")%>' TextMode="MultiLine" />
				</EditItemTemplate>
				<ItemTemplate>
					<asp:label runat="server" ID="MsgBodyLBL" cssclass="input" Text='<%# Bind("MsgBody")%>' />
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
	</asp:GridView>
	<asp:SqlDataSource ID="SqlDataSource1" 
					   runat="server" 
				       SelectCommand="p_gv_SelectEmailTemplates @RestID"
					   UpdateCommand="p_gv_UpdateEmailTemplate @mID,@Action,@MsgBody">
		<SelectParameters>
			<asp:sessionparameter name="RestID" sessionfield="RestID" /> 
		</SelectParameters>
		<UpdateParameters>
			<asp:parameter name="mID" type="String" />
			<asp:parameter name="Action" type="String" />
			<asp:parameter name="MsgBody" type="String" />
		</UpdateParameters>
	</asp:SqlDataSource>
    </div> 
</div>
</form>
</body>