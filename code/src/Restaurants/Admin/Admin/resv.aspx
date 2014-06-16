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
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        ResvSettingsDS.ConnectionString = connectionObject("connectionStringApp")
        If Not Page.IsPostBack Then
            getOpenTableAddress()
        End If
    End Sub

	Private Sub getOpenTableAddress()
        Dim dt As New DataTable()
        Dim connection As New SqlConnection(connectionObject("connectionStringApp"))
		connection.Open()
		Dim sqlCmd As New SqlCommand("EXEC p_GetOpenTableAddress @RestID", connection)
		Dim sqlDa As New SqlDataAdapter(sqlCmd)
	   
		sqlCmd.Parameters.AddWithValue("@RestID", Session("RestID"))
		sqlDa.Fill(dt)
		If dt.Rows.Count > 0 Then
			OpenTableLink.Text = dt.Rows(0)("OpenTableLink").ToString()
		End If
		connection.Close()
	End Sub
	
	Sub ResvSettingsData_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
        Dim conn As New SqlConnection(connectionObject("connectionStringApp"))
		Try
			If e.CommandName.Equals("Save") Then
				Dim btnNew As LinkButton = TryCast(e.CommandSource, LinkButton)
				Dim row As GridViewRow = TryCast(btnNew.NamingContainer, GridViewRow)
				If row Is Nothing Then
					Return
				End If

				Dim CfgID As TextBox = TryCast(row.FindControl("CfgID"), TextBox)
				Dim ResvWeeksInAdvance As TextBox = TryCast(row.FindControl("ResvWeeksInAdvance"), TextBox)
				Dim ResvWeekDayStart As TextBox = TryCast(row.FindControl("ResvWeekDayStart"), TextBox)
				Dim ResvWeekDayStop As TextBox = TryCast(row.FindControl("ResvWeekDayStop"), TextBox)
				Dim ResvStartTime As TextBox = TryCast(row.FindControl("ResvStartTime"), TextBox)
				Dim ResvStopTime As TextBox = TryCast(row.FindControl("ResvStopTime"), TextBox)
				Dim ResvInterval As TextBox = TryCast(row.FindControl("ResvInterval"), TextBox)
				Dim ResvTableThreshold As TextBox = TryCast(row.FindControl("ResvTableThreshold"), TextBox)
				Dim ResvCCAddress As TextBox = TryCast(row.FindControl("ResvCCAddress"), TextBox)

				Dim cmd As New SqlCommand("EXEC p_UpdateReservationConfigAll @CfgID, @ResvWeeksInAdvance, @ResvWeekDayStart, @ResvWeekDayStop, @ResvStartTime, @ResvStopTime, @ResvInterval, @ResvTableThreshold, @ResvCCAddress", conn)

				cmd.Parameters.AddWithValue("CfgID", CfgID.Text)
				cmd.Parameters.AddWithValue("ResvWeeksInAdvance", ResvWeeksInAdvance.Text)
				cmd.Parameters.AddWithValue("ResvWeekDayStart", ResvWeekDayStart.Text)
				cmd.Parameters.AddWithValue("ResvWeekDayStop", ResvWeekDayStop.Text)
				cmd.Parameters.AddWithValue("ResvStartTime", ResvStartTime.Text)
				cmd.Parameters.AddWithValue("ResvStopTime", ResvStopTime.Text)
				cmd.Parameters.AddWithValue("ResvInterval", ResvInterval.Text)
				cmd.Parameters.AddWithValue("ResvTableThreshold", ResvTableThreshold.Text)
				cmd.Parameters.AddWithValue("ResvCCAddress", ResvCCAddress.Text)
				conn.Open()
				If cmd.ExecuteNonQuery() = 1 Then
					ResvSettingsData.DataBind()
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
				
		sqlCmd = "EXECUTE p_SetOpenTableAddress '" & Session("RestID") & "','" & _
													OpenTableLink.Text & "'"

		objCmd = New SQLCommand(sqlCmd, objConn)
		objConn.Open()
		objCmd.ExecuteNonQuery()
		objConn.Close()

		Response.Redirect("resv.aspx")

	End Sub

</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us">
<head runat="server">
<title>Admin Control Panel</title>
<script type="text/javascript">
	function showMe(id1,id2) {
		var obj1 = document.getElementById(id1);
		var obj2 = document.getElementById(id2);

		if (obj1.style.visibility=="hidden") { 
			obj1.style.visibility = "visible";
			obj2.style.visibility = "hidden";
		} else {
			obj1.style.visibility = "hidden";
			obj2.style.visibility = "visible";
		}
	}
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
</style>
</head>
<body>
<form runat="server">
<ajaxToolkit:ToolkitScriptManager runat="Server" EnableScriptGlobalization="true"  EnableScriptLocalization="true" ID="ScriptManager1" />
<center><asp:label runat="server" id="msg" /></center><br><br>
Reservations Enabled? 
			<input type="checkbox" name="c1" checked onclick="showMe('div77','div79')" value="Show Active"><br>
			<div id="div79" style="visibility:hidden;">
			OpenTable Link: <asp:textbox id="OpenTableLink" name="OpenTableLink" runat="server" /><asp:Button id="btnSubmit2" Text="Save" Runat="server" cssclass="input" onclick="SubmitButton2_Click" />
			</div>
			<div id="div77">
			<br>		
				<asp:GridView runat="server" 
							  DataKeyField="CfgID" 
							  DataSourceID="ResvSettingsDS" 
							  ID="ResvSettingsData"
							  AutoGenerateColumns="false" 
							  SelectedIndex="0" 
							  GridLines="Vertical"
							  cellpadding="3"
							  PageSize="50"
							  CssClass="GridViewStyle"
							  OnRowCommand="ResvSettingsData_RowCommand"
							  >
							  <Columns>
								<asp:TemplateField HeaderText="ID" 
												   itemstyle-verticalalign="Top" 
												   itemstyle-horizontalalign="center"
												   itemstyle-width="2%"
												   >
									<ItemTemplate>
										<asp:TextBox ID="CfgID" columns="1" runat="server" cssclass="input" Text='<%# Bind("CfgID") %>' ReadOnly></asp:TextBox>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Number of Weeks in Advance that are available for scheduling" 
												   itemstyle-verticalalign="Top" 
												   itemstyle-horizontalalign="center"
												   itemstyle-width="17%"
												   >
									<ItemTemplate>
										<asp:TextBox ID="ResvWeeksInAdvance" columns="10" runat="server" cssclass="input3" Text='<%# Bind("ResvWeeksInAdvance") %>'></asp:TextBox>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Days of Week that reservations are accepted" 
												   itemstyle-verticalalign="Top" 
												   itemstyle-horizontalalign="center"
												   itemstyle-width="20%"
												   >
									<ItemTemplate>
										[Start] - <asp:TextBox ID="ResvWeekDayStart" columns="10" runat="server" cssclass="input3" Text='<%# Bind("ResvWeekDayStart") %>'></asp:TextBox><br>
								        [Stop] - <asp:TextBox ID="ResvWeekDayStop" columns="10" runat="server" cssclass="input3" Text='<%# Bind("ResvWeekDayStop") %>'></asp:TextBox>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Hours that reservations are accepted" 
												   itemstyle-verticalalign="Top" 
												   itemstyle-horizontalalign="center"
												   itemstyle-width="20%"
												   >
									<ItemTemplate>
										[Start] - <asp:TextBox ID="ResvStartTime" columns="10" runat="server" cssclass="input3" Text='<%# Bind("ResvStartTime") %>'></asp:TextBox><br>
								        [Stop] - <asp:TextBox ID="ResvStopTime" columns="10" runat="server" cssclass="input3" Text='<%# Bind("ResvStopTime") %>'></asp:TextBox>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Reservation interval" 
												   itemstyle-verticalalign="Top" 
												   itemstyle-horizontalalign="center"
												   itemstyle-width="17%"
												   >
									<ItemTemplate>
										<asp:TextBox ID="ResvInterval" columns="10" runat="server" cssclass="input3" Text='<%# Bind("ResvInterval") %>'></asp:TextBox>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Reservation table threshold per interval" 
												   itemstyle-verticalalign="Top" 
												   itemstyle-horizontalalign="center"
												   itemstyle-width="17%"
												   >
									<ItemTemplate>
										<asp:TextBox ID="ResvTableThreshold" columns="10" runat="server" cssclass="input3" Text='<%# Bind("ResvTableThreshold") %>'></asp:TextBox>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Reservation CC Address" 
												   itemstyle-verticalalign="Top" 
												   itemstyle-horizontalalign="center"
												   itemstyle-width="17%"
												   >
									<ItemTemplate>
										<asp:TextBox ID="ResvCCAddress" columns="10" runat="server" cssclass="input3" Text='<%# Bind("ResvCCAddress") %>'></asp:TextBox>
									</ItemTemplate>
								</asp:TemplateField>
							    <asp:TemplateField HeaderText="">
									<ItemTemplate>
										<asp:linkbutton id="btnNew" runat="server" commandname="Save" text="Save" />
									</ItemTemplate>			 
								</asp:TemplateField>
							 </Columns>
							 <FooterStyle CssClass="GridViewFooterStyle" />
							 <RowStyle CssClass="GridViewRowStyle" />    
							 <PagerStyle CssClass="GridViewPagerStyle" />
							 <AlternatingRowStyle CssClass="GridViewAlternatingRowStyle" />
							 <HeaderStyle CssClass="GridViewHeaderStyle" />
				</asp:Gridview>		
				<asp:SqlDataSource ID="ResvSettingsDS" 
								   runat="server" 
								   SelectCommand="p_SelectReservationsConfigSettings @RestID">
					<SelectParameters>
					  <asp:sessionparameter name="RestID" sessionfield="RestID" /> 
					</SelectParameters>
				</asp:SqlDataSource>
				<br>
				<hr>
				<br>
				Existing Reservations
				<iframe frameborder="0" src="resvEditor.aspx" width="990px" height="700"></iframe>
			</div>
</form>
</body>