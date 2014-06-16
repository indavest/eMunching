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
	Sub Page_Load(o As Object, e As EventArgs)
		Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
        Dim objConn As New SqlConnection(connectionObject("connectionStringApp"))
		objConn.Open()

		'If Page.IsPostBack Then
		'	Dim objCmd As SQLCommand
		'	Dim sqlString As String = "Update tbTest Set fldContent=? Where id=?"
		'	objCmd = New OleDbCommand(sqlString, Connection)
'
'			objCmd.Parameters.Add(New OleDbParameter("@fldContent", OleDbType.VarChar))
'			objCmd.Parameters("@fldContent").Value = editor.Content
'			objCmd.Parameters.Add(New OleDbParameter("@id", OleDbType.[Integer]))
'			objCmd.Parameters("@id").Value = 1

'			objCmd.ExecuteNonQuery()
'		Else
			Dim sqlString As String = "p_SelectEmailTemplate '" & Session("RestID") & "','NewUser'"
			Dim eAdapter As New SqlDataAdapter(sqlString, objConn)
			Dim eTable As New DataTable()
			Dim CommandBuilder As New SqlCommandBuilder(eAdapter)

			eAdapter.Fill(eTable)
			'editor5.Content = DirectCast(eTable.Rows(0)(0), String)
			eAdapter.Dispose()
			eTable.Dispose()
'		End If

		objConn.Close()
		objConn.Dispose()
	End Sub
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us">
<head runat="server">
<title>Admin Control Panel</title>
<script type="text/javascript" src="/js/jquery-1.4.2.min.js"></script>
<link rel="stylesheet" type="text/css" href="/themes/skin2.css" />
<link rel="stylesheet" type="text/css" href="/themes/skin1.css" />
<script type="text/javascript">
	$(document).ready(function() {

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
</head>
<body>
<form runat="server">
<ajaxToolkit:ToolkitScriptManager runat="Server" EnableScriptGlobalization="true"  EnableScriptLocalization="true" ID="ScriptManager1" />
<ul class="tabs">
				<li><a href="#tab5">New User</a></li>
				<li><a href="#tab6">Forgot Pwd</a></li>
				<li><a href="#tab7">Order Ack</a></li>
				<li><a href="#tab8">Order Cancl</a></li>
				<li><a href="#tab9">Resv Conf.</a></li>
				<li><a href="#tab10">Resv Cancl</a></li>
			</ul>
			<div class="tab_container">
				<div id="tab5" class="tab_content">
					<HTMLEditor:Editor runat="server" 
									   Id="editor5" 
									   Height="300px" 
									   NoUnicode="true" 
									   AutoFocus="true" 
									   Width="100%" 
									   />
					<asp:Label runat="server" ID="ContentChangedLabel5" />
					<br />
					<asp:Button runat="server" Text="Submit content" ID="submit5" />
				</div>
				<div id="tab6" class="tab_content">
					<HTMLEditor:Editor runat="server" Id="editor6" Height="300px" AutoFocus="true" Width="100%" />
					<asp:Label runat="server" ID="ContentChangedLabel6" />
					<br />
					<asp:Button runat="server" Text="Submit content" ID="submit6" />
				</div>
				<div id="tab7" class="tab_content">
					<HTMLEditor:Editor runat="server" Id="editor7" Height="300px" AutoFocus="true" Width="100%" />
					<asp:Label runat="server" ID="ContentChangedLabel7" />
					<br />
					<asp:Button runat="server" Text="Submit content" ID="submit7" />
				</div>
				<div id="tab8" class="tab_content">
					<HTMLEditor:Editor runat="server" Id="editor8" Height="300px" AutoFocus="true" Width="100%" />
					<asp:Label runat="server" ID="ContentChangedLabel8" />
					<br />
					<asp:Button runat="server" Text="Submit content" ID="submit8" />
				</div>
				<div id="tab9" class="tab_content">
					<HTMLEditor:Editor runat="server" Id="editor9" Height="300px" AutoFocus="true" Width="100%" />
					<asp:Label runat="server" ID="ContentChangedLabel9" />
					<br />
					<asp:Button runat="server" Text="Submit content" ID="submit9" />
				</div>
				<div id="tab10" class="tab_content">
					<HTMLEditor:Editor runat="server" Id="editor10" Height="300px" AutoFocus="true" Width="100%" />
					<asp:Label runat="server" ID="ContentChangedLabel10" />
					<br />
					<asp:Button runat="server" Text="Submit content" ID="submit10" />
				</div>
			</div>
</form>
</body>