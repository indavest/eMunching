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
	Sub GridView1_RowCommand(sender As Object, e As GridViewCommandEventArgs)
		Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
Dim conn As New SqlConnection(connectionObject("connectionStringApp"))
		Try
			If e.CommandName.Equals("New") Then
				Dim btnNew As LinkButton = TryCast(e.CommandSource, LinkButton)
				Dim row As GridViewRow = TryCast(btnNew.NamingContainer, GridViewRow)
				If row Is Nothing Then
					Return
				End If

				Dim txtResvNameTextBox As TextBox = TryCast(GridView1.FooterRow.FindControl("ResvNameTextBox"), TextBox)
				Dim txtResvCallBackNumTextBox As TextBox = TryCast(GridView1.FooterRow.FindControl("ResvCallBackNumTextBox"), TextBox)
				Dim RestLocaNameDDL As DropDownList = TryCast(GridView1.FooterRow.FindControl("RestLocaNameDDL"), DropDownList)
				Dim RequestedByDDL As DropDownList = TryCast(GridView1.FooterRow.FindControl("RequestedByDDL"), DropDownList)
				Dim txtResvNumGuestsTextBox As TextBox = TryCast(GridView1.FooterRow.FindControl("ResvNumGuestsTextBox"), TextBox)
				Dim txtResvTimeslotTextBox As TextBox = TryCast(GridView1.FooterRow.FindControl("ResvTimeslotTextBox"), TextBox)

				Dim cmd As New SqlCommand("p_Svc_CreateReservations @ResName,@CallBackNumber,@RestaurantID,@RestaurantLocaID,@UserID,@NumGuests,@TimeSlot", conn)
				cmd.Parameters.AddWithValue("ResName", txtResvNameTextBox.Text)
				cmd.Parameters.AddWithValue("CallBackNumber", txtResvCallBackNumTextBox.Text)
				cmd.Parameters.AddWithValue("RestaurantID", Session("RestID").ToString)
				cmd.Parameters.AddWithValue("RestaurantLocaID", RestLocaNameDDL.selectedItem.Value)
				cmd.Parameters.AddWithValue("UserID", RequestedByDDL.selectedItem.Value)
				cmd.Parameters.AddWithValue("NumGuests", txtResvNumGuestsTextBox.Text)
				cmd.Parameters.AddWithValue("TimeSlot", txtResvTimeslotTextBox.Text)
				conn.Open()
				If cmd.ExecuteNonQuery() = 1 Then
					GridView1.DataBind()
				End If
			ElseIf e.CommandName.Equals("NoDataInsert") Then
				Dim btnNoDataInsert As Button = TryCast(e.CommandSource, Button)
				Dim row2 As GridViewRow = TryCast(btnNoDataInsert.NamingContainer, GridViewRow)
				If row2 Is Nothing Then
					Return
				End If

				Dim NoDatatxtResvNameTextBox As TextBox = TryCast(GridView1.Controls(0).Controls(0).FindControl("NoDataResvNameTextBox"), TextBox)
				Dim NoDatatxtResvCallBackNumTextBox As TextBox = TryCast(GridView1.Controls(0).Controls(0).FindControl("NoDataResvCallBackNumTextBox"), TextBox)
				Dim NoDataRestLocaNameDDL As DropDownList = TryCast(GridView1.Controls(0).Controls(0).FindControl("NoDataRestLocaNameDDL"), DropDownList)
				Dim NoDataRequestedByDDL As DropDownList = TryCast(GridView1.Controls(0).Controls(0).FindControl("NoDataRequestedByDDL"), DropDownList)
				Dim NoDatatxtResvNumGuestsTextBox As TextBox = TryCast(GridView1.Controls(0).Controls(0).FindControl("NoDataResvNumGuestsTextBox"), TextBox)
				Dim NoDatatxtResvTimeslotTextBox As TextBox = TryCast(GridView1.Controls(0).Controls(0).FindControl("NoDataResvTimeslotTextBox"), TextBox)

				Dim cmd2 As New SqlCommand("p_Svc_CreateReservations @ResName,@CallBackNumber,@RestaurantID,@RestaurantLocaID,@UserID,@NumGuests,@TimeSlot", conn)
				cmd2.Parameters.AddWithValue("ResName", NoDatatxtResvNameTextBox.Text)
				cmd2.Parameters.AddWithValue("CallBackNumber", NoDatatxtResvCallBackNumTextBox.Text)
				cmd2.Parameters.AddWithValue("RestaurantID", Session("RestID").ToString)
				cmd2.Parameters.AddWithValue("RestaurantLocaID", NoDataRestLocaNameDDL.selectedItem.Value)
				cmd2.Parameters.AddWithValue("UserID", NoDataRequestedByDDL.selectedItem.Value)
				cmd2.Parameters.AddWithValue("NumGuests", NoDatatxtResvNumGuestsTextBox.Text)
				cmd2.Parameters.AddWithValue("TimeSlot", NoDatatxtResvTimeslotTextBox.Text)
				conn.Open()
				If cmd2.ExecuteNonQuery() = 1 Then
					GridView1.DataBind()
				End If
			End If

		Catch ex As Exception
			msg.text = ex.message
		Finally
			conn.Close()
		End Try
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
Reservations Enabled? 
			<input type="checkbox" name="c1" checked onclick="showMe('div77','div79')" value="Show Active"><br>
			<div id="div79" style="visibility:hidden;">
			OpenTable Link: <asp:textbox id="OpenTableLink" name="OpenTableLink" runat="server" />
			</div>
			<div id="div77">
			<br>		
				<asp:GridView runat="server" 
							  DataKeyField="CfgID" 
							  DataSourceID="ResvDS" 
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
				<asp:SqlDataSource ID="ResvDS" 
								   runat="server" 
								   ConnectionString="<%$ ConnectionStrings:VCon %>"
								   SelectCommand="p_SelectReservationsConfigSettings @RestID"
								   UpdateCommand="p_UpdateReservationConfigAll @CfgID, @ResvWeeksInAdvance, @ResvWeekDayStart, @ResvWeekDayStop, @ResvStartTime, @ResvStopTime, @ResvInterval, @ResvTableThreshold">
					<SelectParameters>
					  <asp:sessionparameter name="RestID" sessionfield="RestID" /> 
					</SelectParameters>
					<UpdateParameters>
					  <asp:Parameter Name="CfgID" Type="Int32" />
					  <asp:Parameter Name="ResvWeeksInAdvance" Type="String" />
					  <asp:Parameter Name="ResvWeekDayStart" Type="String" />
					  <asp:Parameter Name="ResvWeekDayStop" Type="String" />
					  <asp:Parameter Name="ResvStartTime" Type="String" />
					  <asp:Parameter Name="ResvStopTime" Type="String" />
					  <asp:Parameter Name="ResvInterval" Type="String" />
					  <asp:Parameter Name="ResvTableThreshold" Type="String" />
					</UpdateParameters>
				</asp:SqlDataSource>
				<br>
				<hr>
				<br>
				Existing Reservations
				<!--<iframe frameborder="0" src="resvEditor.aspx" width="990px" height="700"></iframe>-->
				<asp:label runat="server" id="msg" />
				&nbsp;&nbsp;&nbsp;&nbsp;
				
				<asp:GridView ID="GridView1" 
							  runat="server"
							  AutoGenerateColumns="False" 
							  DataKeyNames="ResvID"
							  DataSourceID="SqlDataSource1" 
							  ShowFooter="true" 
							  GridLines="None"
							  AllowPaging="True" 
							  AllowSorting="True" 
							  CssClass="mGrid"
							  emptydatatext="No data in the data source."
							  PagerStyle-CssClass="pgr"
							  AlternatingRowStyle-CssClass="alt"
							  OnRowCommand="GridView1_RowCommand">
					<EmptyDataTemplate>
						<table class="mGrid">
							<tr>
								<th>Reservation Name:</th>
								<td><asp:TextBox ID="NoDataResvNameTextBox" Runat="server" cssclass="input"></asp:TextBox></td>
							</tr>
							<tr>
								<th>Call Back Number:</th>
								<td><asp:TextBox ID="NoDataResvCallBackNumTextBox" Runat="server" cssclass="input"></asp:TextBox></td>
							</tr>
							<tr>
								<th>Location:</th>
								<td>
									<asp:DropDownList ID="NoDataRestLocaNameDDL"
													  cssclass="input"
													  Runat="server"
													  DataSourceID="AvailRestLocas" 
													  DataTextField="Name" 
													  DataValueField="LocaID">
									<asp:ListItem Text="<Select a Location>" Value="00000" />
									</asp:DropDownList>
									<asp:SqlDataSource ID="AvailRestLocas" 
												   runat="server" 
												   ConnectionString="<%$ ConnectionStrings:VCon %>"
												   SelectCommand="p_SelectRestaurantLocations @RestID">
										<SelectParameters>
											<asp:sessionparameter name="RestID" sessionfield="RestID" /> 
										</SelectParameters>
									</asp:SqlDataSource>
								</td>
							</tr>
							<tr>
								<th>Requested By:</th>
								<td>
									<asp:DropDownList ID="NoDataRequestedByDDL"
													cssclass="input"
													Runat="server"
													DataSourceID="AvailUsers" 
													DataTextField="UserFullName" 
													DataValueField="ID">
										<asp:ListItem Text="<Select a User>" Value="00000" />
										<asp:ListItem Text="Call-In" Value="99999" />
									</asp:DropDownList>
									<asp:SqlDataSource ID="AvailUsers" 
												   runat="server" 
												   ConnectionString="<%$ ConnectionStrings:VCon %>"
												   SelectCommand="p_gv_SelectRestaurantUsers @RestID">
										<SelectParameters>
											<asp:sessionparameter name="RestID" sessionfield="RestID" /> 
										</SelectParameters>
									</asp:SqlDataSource>
								</td>
							</tr>
							<tr>
								<th>Number of Guests:</th>
								<td><asp:TextBox ID="NoDataResvNumGuestsTextBox" Runat="server" cssclass="input" size="5"></asp:TextBox></td>
							</tr>
							<tr>
								<th>Time Slot:</th>
								<td><asp:TextBox ID="NoDataResvTimeslotTextBox" Runat="server" cssclass="input"></asp:TextBox> Format: <i>YYYY-MM-DD HH:MM PM</i></td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="2" align="Center"><asp:Button runat="server" cssclass="input" ID="NoDataInsert" CommandName="NoDataInsert" Text="Create Reservation"/></td>
							</tr>
						</table>
					</EmptyDataTemplate>
					<Columns>
						<asp:CommandField ShowEditButton="False"/> 
						<asp:TemplateField>
							  <ItemTemplate>
								<asp:Button ID="btnDel" 
											runat="server" 
											Text="Clear"
											cssclass="input"
											CommandName="Delete" 
											OnClientClick="return confirm('Are you sure you want to Complete the Reservation?');" />
							  </ItemTemplate>
						</asp:TemplateField>

						 <asp:TemplateField HeaderText="Resv Name" SortExpression="ResvName" itemstyle-wrap="true">
							<ItemTemplate>
								<asp:Label ID="Label7" runat="server" Text='<%# Bind("ResvName") %>'></asp:Label>
							</ItemTemplate>
							<FooterTemplate>
								<asp:TextBox ID="ResvNameTextBox" Runat="server" cssclass="input"></asp:TextBox>
							</FooterTemplate>                 
						</asp:TemplateField>

						 <asp:TemplateField HeaderText="Callback Num" SortExpression="ResvCallBackNum" itemstyle-wrap="true">
							<ItemTemplate>
								<asp:Label ID="Label8" runat="server" Text='<%# Bind("ResvCallBackNum") %>'></asp:Label>
							</ItemTemplate>
							<FooterTemplate>
								<asp:TextBox ID="ResvCallBackNumTextBox" Runat="server" cssclass="input"></asp:TextBox>
							</FooterTemplate>                 
						</asp:TemplateField>

						 <asp:TemplateField HeaderText="Location" SortExpression="RestLocaName" ItemStyle-HorizontalAlign="Center">
							<ItemTemplate>
								<asp:Label ID="Label9" runat="server" Text='<%# Bind("RestLocaName") %>'></asp:Label>
							</ItemTemplate>
							<FooterTemplate>
								<asp:DropDownList ID="RestLocaNameDDL"
												  cssclass="input"
												  Runat="server"
												  DataSourceID="AvailRestLocas" 
												  DataTextField="Name" 
												  DataValueField="LocaID">
									<asp:ListItem Text="<Select a Location>" Value="00000" />
								</asp:DropDownList>
								<asp:SqlDataSource ID="AvailRestLocas" 
												   runat="server" 
												   ConnectionString="<%$ ConnectionStrings:VCon %>"
												   SelectCommand="p_SelectRestaurantLocations @RestID">
									<SelectParameters>
										<asp:sessionparameter name="RestID" sessionfield="RestID" /> 
									</SelectParameters>
								</asp:SqlDataSource>
							</FooterTemplate>                 
						</asp:TemplateField>

						 <asp:TemplateField HeaderText="Requested By" SortExpression="RequestedBy" ItemStyle-HorizontalAlign="Center">
							<ItemTemplate>
								<asp:Label ID="Label10" runat="server" Text='<%# Bind("RequestedBy") %>'></asp:Label>
							</ItemTemplate>
							<FooterTemplate>
								<asp:DropDownList ID="RequestedByDDL"
												  cssclass="input"
												  Runat="server"
												  DataSourceID="AvailUsers" 
												  DataTextField="UserFullName" 
												  DataValueField="ID">
									<asp:ListItem Text="<Select a User>" Value="00000" />
									<asp:ListItem Text="Call-In" Value="99999" />
								</asp:DropDownList>
								<asp:SqlDataSource ID="AvailUsers" 
												   runat="server" 
												   ConnectionString="<%$ ConnectionStrings:VCon %>"
												   SelectCommand="p_gv_SelectRestaurantUsers @RestID">
									<SelectParameters>
										<asp:sessionparameter name="RestID" sessionfield="RestID" /> 
									</SelectParameters>
								</asp:SqlDataSource>
							</FooterTemplate>                 
						</asp:TemplateField>

						 <asp:TemplateField HeaderText="Num Guests" SortExpression="ResvNumGuests" ItemStyle-HorizontalAlign="Center">
							<ItemTemplate>
								<asp:Label ID="Label11" runat="server" Text='<%# Bind("ResvNumGuests") %>'></asp:Label>
							</ItemTemplate>
							<FooterTemplate>
								<asp:TextBox ID="ResvNumGuestsTextBox" Runat="server" cssclass="input" size="5"></asp:TextBox>
							</FooterTemplate>                 
						</asp:TemplateField>

						<asp:TemplateField HeaderText="Time Slot" SortExpression="ResvTimeslot" ItemStyle-HorizontalAlign="Center">
							<ItemTemplate>
								<asp:Label ID="Label12" runat="server" Text='<%# Bind("ResvTimeslot") %>'></asp:Label>
							</ItemTemplate>
							<FooterTemplate>
								<asp:TextBox ID="ResvTimeslotTextBox" Runat="server" cssclass="input"></asp:TextBox><br>Format: <i>YYYY-MM-DD HH:MM PM</i>
							</FooterTemplate>                 
						</asp:TemplateField>
						
						
						<asp:templatefield>                  
								<footertemplate>
									  <asp:linkbutton id="btnNew" runat="server" commandname="New" text="Save" />
								</footertemplate>
						</asp:templatefield>
					   
					</Columns>
				</asp:GridView>
				<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:VCon %>"
					ProviderName="System.Data.SqlClient" 
					DeleteCommand="UPDATE Reservations SET Active=0 WHERE ID = @ResvID" 
					SelectCommand="p_gv_SelectRestaurantReservations @RestID">
					<DeleteParameters>
						<asp:Parameter Name="ResvID" Type="Int32" />
					</DeleteParameters>
					
					<SelectParameters>
						<asp:sessionparameter name="RestID" sessionfield="RestID" /> 
					</SelectParameters>
				</asp:SqlDataSource>
			</div>
</form>
</body>