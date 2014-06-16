<%@ Page Language="VB" debug="true" ValidateRequest="false" %>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>
<script runat="server">
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        dsFAQ.ConnectionString = connectionObject("connectionStringApp")
    End Sub
    
	Protected Sub SubmitButton_Click(sender As Object, e As EventArgs)

		Dim objConn As New SqlConnection(connectionObject("connectionStringApp"))
		Dim objCmd As SQLCommand
		Dim sqlCmd As String
				
		sqlCmd = "EXECUTE p_CreateSupportTicket '" & Session("RestID") & "','" & _
													 Session("UserLogin") & "','" & _
													 txtTitle.Text & "', '" & _
													 txtDesc.Text & "'"

		objCmd = New SQLCommand(sqlCmd, objConn)
		objConn.Open()
		objCmd.ExecuteNonQuery()
		objConn.Close()

		Response.Redirect("Support.aspx")

	End Sub
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us">
<head runat="server">
<title>Admin Control Panel - Support</title>
<script type="text/javascript" src="/js/carousel/jquery-1.4.2.min.js"></script>
<link rel="stylesheet" type="text/css" href="/themes/skin2.css" />
<link rel="stylesheet" type="text/css" href="/themes/skin1.css" />
<link rel="stylesheet" type="text/css" href="/themes/grid.css" />
<link rel="stylesheet" type="text/css" href="/themes/tabs.css" />
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
<style type="text/css">
		.header { font-size: larger; font-weight: bold; cursor: hand; cursor:pointer;
				   background-color:#cccccc; font-family: Verdana; }
		.details { display:none; visibility:hidden; background-color:#eeeeee; font-family: Verdana; width: 650px;}
	</style>
	<script language="JavaScript">
	  function ToggleDisplay(id)
	  {
		var elem = document.getElementById('d' + id);
		if (elem) 
		{
		  if (elem.style.display != 'block') 
		  {
			elem.style.display = 'block';
			elem.style.visibility = 'visible';
		  } 
		  else
		  {
			elem.style.display = 'none';
			elem.style.visibility = 'hidden';
		  }
		}
	  }
	</script>
</head>
<body>
	<form runat="server">
		<ul class="tabs">
				<li><a href="#tab1">FAQ's</a></li>
				<li><a href="#tab2">Create a Ticket</a></li>
				<li><a href="#tab3">Existing Tickets</a></li>
			</ul>
			<div class="tab_container">
				<div id="tab1" class="tab_content">
					<h2>Admin Console FAQ's</h2><br>
						Please select a topic to review the question and answers:<br>
						<asp:Repeater id="rptFAQs" runat="server" DataSourceID="dsFAQ">
									   <HeaderTemplate>
											<table cellspacing="5" cellpadding="10" border="0" align="left" >
									   </HeaderTemplate>
									   <ItemTemplate>
												<tr>
													<td>
													 <div align="left" id='h<%# Eval("ID") %>' class="header" onclick='ToggleDisplay(<%# Eval("ID") %>);'>
														<%# Eval("Title") %>
													 </div>
														 
													 <div id='d<%# Eval("ID") %>' class="details">
													   <b>Category:</b> <%# Eval("Name") %><br />
													   <b>Submitted By:</b> <%# Eval("SubmittedBy") %><br />
													   <b>Last Updated:</b> <%# Eval("ModifiedDate") %><br />
													   <hr>
													   <b>FAQ:</b><br />
													   <%# Eval("Question") %><br><br>
													   <b>Answer:</b><br>
													   <%# Eval("Solution") %><br><br>
													 </div>
													</td>
												</tr>
									   </ItemTemplate>
									   <FooterTemplate>
											</table>
									   </FooterTemplate>
									</asp:Repeater>
									<asp:SqlDataSource ID="dsFAQ" 
													   runat="server" 
													   ProviderName="System.Data.SqlClient" 
													   SelectCommand="p_gv_GetFAQs"
													   >
									</asp:SqlDataSource>
								
				</div>
				<div id="tab2" class="tab_content">
					<h2>Create a Support Ticket</h2>
						<p>Do you still have a question, comment or concern that is not answered in the above FAQ's?<br />Fill out this form and an eMunching Support Specialist will follow up with you as soon as possible.</p><br />
						<p>Please keep the following in mind:</p>
						<ul>
							<li>* The title will become the ticket summary.</li>
							<li>* You will recieve a copy of the help desk ticket. Reply to a ticket alert and your email will be posted as a ticket comment.</li>
						</ul>
						<br /><br />
						<table cellspacing="0" cellpadding="5" border="0">
							<tr>
								<th align="left">Title (Short Description):</th>
								<td><asp:textbox runat="server" id="txtTitle" size="75" /></td>
							</tr>
							<tr>
								<th align="left">Description of Issue:</th>
								<td><asp:textbox runat="server" id="txtDesc" TextMode="Multiline" cols="50" rows="5" /></td>
							</tr>
							<tr>
								<td colspan="2" align="center">
								<asp:Button	id="btnSubmit" Text="Save" Runat="server" cssclass="input" onclick="SubmitButton_Click" />
								</td>
							</tr>
						</table>

				</div>
				<div id="tab3" class="tab_content">
					<h2>Existing Support Ticket</h2>
				</div>
			</div>

	</form>
</body>