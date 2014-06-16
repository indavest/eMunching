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
Reservations Enabled? 
			<input type="checkbox" name="c1" checked onclick="showMe('div77','div79')" value="Show Active"><br>
			<div id="div79" style="visibility:hidden;">
			OpenTable Link: <asp:textbox id="OpenTableLink" name="OpenTableLink" runat="server" />
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
							  >
							  <Columns>
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
							    <asp:TemplateField HeaderText="">
									<ItemTemplate>
										<asp:Button runat="server" ID="Edit" cssclass="input3" Text="Save" CommandName="Update" />
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
								   ConnectionString="<%$ ConnectionStrings:VCon %>"
								   SelectCommand="p_SelectReservationsConfigSettings @RestID"
								   UpdateCommand="p_UpdateReservationConfigAll @CfgID, @ResvWeeksInAdvance, @ResvWeekDayStart, @ResvWeekDayStop, @ResvStartTime, @ResvStopTime, @ResvInterval, @ResvTableThreshold">
					<SelectParameters>
					  <asp:sessionparameter name="RestID" sessionfield="RestID" /> 
					</SelectParameters>
					<UpdateParameters>
					  <asp:Parameter Name="CfgID" />
					  <asp:Parameter Name="ResvWeeksInAdvance" Type="String" />
					  <asp:Parameter Name="ResvWeekDayStart" Type="String" />
					  <asp:Parameter Name="ResvWeekDayStop" Type="String" />
					  <asp:Parameter Name="ResvStartTime"  />
					  <asp:Parameter Name="ResvStopTime" />
					  <asp:Parameter Name="ResvInterval" />
					  <asp:Parameter Name="ResvTableThreshold" Type="String" />
					</UpdateParameters>
				</asp:SqlDataSource>
				<br>
				<hr>
				<br>
				Existing Reservations
				<iframe frameborder="0" src="resvEditor.aspx" width="990px" height="700"></iframe>
			</div>
</form>
</body>