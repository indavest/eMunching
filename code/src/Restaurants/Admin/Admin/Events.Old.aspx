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

				Dim txtEventNameTextBox As TextBox = TryCast(GridView1.FooterRow.FindControl("EventNameTextBox"), TextBox)
				Dim txtEventDescTextBox As TextBox = TryCast(GridView1.FooterRow.FindControl("DescriptionTextBox"), TextBox)
				Dim RestLocaNameDDL As DropDownList = TryCast(GridView1.FooterRow.FindControl("RestLocaNameDDL"), DropDownList)
				Dim txtDateTextBox As TextBox = TryCast(GridView1.FooterRow.FindControl("DateTextBox"), TextBox)
				Dim EventTimeDDL As DropDownList = TryCast(GridView1.FooterRow.FindControl("EventTimeDDL"), DropDownList)
				Dim cmd As New SqlCommand("p_gv_CreateEvent @Restaurant,@RestLoca,@EventName,@Desc,@Date,@Time", conn)

				cmd.Parameters.AddWithValue("Restaurant", Session("RestID").ToString)
				cmd.Parameters.AddWithValue("RestLoca", RestLocaNameDDL.selectedItem.Value)
				cmd.Parameters.AddWithValue("EventName", txtEventNameTextBox.Text)
				cmd.Parameters.AddWithValue("Desc", txtEventDescTextBox.Text)
				cmd.Parameters.AddWithValue("Date", txtDateTextBox.Text)
				cmd.Parameters.AddWithValue("Time", EventTimeDDL.selectedItem.Value)

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

				Dim NoDatatxtEventNameTextBox As TextBox = TryCast(GridView1.Controls(0).Controls(0).FindControl("NoDataEventNameTextBox"), TextBox)
				Dim NoDatatxtDescTextBox As TextBox = TryCast(GridView1.Controls(0).Controls(0).FindControl("NoDataDescTextBox"), TextBox)
				Dim NoDataRestLocaNameDDL As DropDownList = TryCast(GridView1.Controls(0).Controls(0).FindControl("NoDataRestLocaNameDDL"), DropDownList)
				Dim NoDatatxtDateTextBox As TextBox = TryCast(GridView1.Controls(0).Controls(0).FindControl("NoDataDateTextBox"), TextBox)
				Dim NoDatatxtTimeTextBox As TextBox = TryCast(GridView1.Controls(0).Controls(0).FindControl("NoDataTimeTextBox"), TextBox)
				Dim cmd2 As New SqlCommand("p_gv_CreateEvent @Restaurant,@RestLoca,@EventName,@Desc,@Date,@Time", conn)
		
				cmd2.Parameters.AddWithValue("Restaurant", Session("RestID").ToString)
				cmd2.Parameters.AddWithValue("RestLoca", NoDataRestLocaNameDDL.selectedItem.Value)
				cmd2.Parameters.AddWithValue("EventName", NoDatatxtEventNameTextBox.Text)
				cmd2.Parameters.AddWithValue("Desc", NoDatatxtDescTextBox.Text)
				cmd2.Parameters.AddWithValue("Date", NoDatatxtDateTextBox.Text)
				cmd2.Parameters.AddWithValue("Time", NoDatatxtTimeTextBox.Text)

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
 
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
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
			padding: 20px 0;    
		}
		#container {
			width: 970px;
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
	</style>
</head>
<body>
    <form id="form1" runat="server">
	<ajaxToolkit:ToolkitScriptManager runat="Server" EnableScriptGlobalization="true"  EnableScriptLocalization="true" ID="ScriptManager1" />
    <div id="container">
		<asp:label runat="server" id="msg" />
        &nbsp;&nbsp;&nbsp;&nbsp;
		
        <asp:GridView ID="GridView1" 
					  runat="server"
					  AutoGenerateColumns="False" 
					  DataKeyNames="EventID"
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
						<th>Event Name:</th>
						<td><asp:TextBox ID="NoDataEventNameTextBox" Runat="server" cssclass="input"></asp:TextBox></td>
					</tr>
					<tr>
						<th>Description:</th>
						<td><asp:TextBox ID="NoDataDescTextBox" Runat="server" cssclass="input"></asp:TextBox></td>
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
						<th>Event Date:</th>
						<td><asp:TextBox ID="NoDataDateTextBox" Runat="server" cssclass="input" size="5"></asp:TextBox></td>
					</tr>
					<tr>
						<th>Event Time:</th>
						<td><asp:TextBox ID="NoDataTimeTextBox" Runat="server" cssclass="input"></asp:TextBox> Format: <i>HH:MM PM</i></td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2" align="Center"><asp:Button runat="server" cssclass="input" ID="NoDataInsert" CommandName="NoDataInsert" Text="Create Event"/></td>
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
									OnClientClick="return confirm('Are you sure you want to Delete the Event?');" />
					  </ItemTemplate>
				</asp:TemplateField>

				 <asp:TemplateField HeaderText="Event Name" SortExpression="EventName" itemstyle-wrap="true">
                    <ItemTemplate>
                        <asp:Label ID="Label7" runat="server" Text='<%# Bind("EventName") %>'></asp:Label>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox ID="EventNameTextBox" Runat="server" cssclass="input"></asp:TextBox>
                    </FooterTemplate>                 
                </asp:TemplateField>

				 <asp:TemplateField HeaderText="Desc" SortExpression="Description" itemstyle-wrap="true">
                    <ItemTemplate>
                        <asp:Label ID="Label8" runat="server" Text='<%# Bind("Description") %>'></asp:Label>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox ID="DescriptionTextBox" Runat="server" cssclass="input"></asp:TextBox>
                    </FooterTemplate>                 
                </asp:TemplateField>

				 <asp:TemplateField HeaderText="Location" SortExpression="LocaName" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Label ID="Label9" runat="server" Text='<%# Bind("LocaName") %>'></asp:Label>
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

				 <asp:TemplateField HeaderText="Event Date" SortExpression="Date" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Label ID="Label11" runat="server" Text='<%# Bind("Date") %>'></asp:Label>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox ID="DateTextBox" Runat="server" cssclass="input" size="7"></asp:TextBox>
						<asp:ImageButton runat="Server" ID="DateTextBoxImage" ImageUrl="/images/Calendar_scheduleHS.png" AlternateText="Click to show calendar" /><br />
						<ajaxToolkit:CalendarExtender ID="DateTextBoxExtender" runat="server" cssclass="input" TargetControlID="DateTextBox" PopupButtonID="DateTextBoxImage" />
                    </FooterTemplate>                 
                </asp:TemplateField>

				<asp:TemplateField HeaderText="Time Slot" SortExpression="EventTime" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Label ID="Label12" runat="server" Text='<%# Bind("EventTime") %>'></asp:Label>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:dropdownlist ID = "EventTimeDDL" Runat="server" cssclass="input">
							<asp:listitem value="1:00 AM" Text="1:00 AM" />
							<asp:listitem value="1:30 AM" Text="1:30 AM" />
							<asp:listitem value="2:00 AM" Text="2:00 AM" />
							<asp:listitem value="2:30 AM" Text="2:30 AM" />
							<asp:listitem value="3:00 AM" Text="3:00 AM" />
							<asp:listitem value="3:30 AM" Text="3:30 AM" />
							<asp:listitem value="4:00 AM" Text="4:00 AM" />
							<asp:listitem value="4:30 AM" Text="4:30 AM" />
							<asp:listitem value="5:00 AM" Text="5:00 AM" />
							<asp:listitem value="5:30 AM" Text="5:30 AM" />
							<asp:listitem value="6:00 AM" Text="6:00 AM" />
							<asp:listitem value="6:30 AM" Text="6:30 AM" />
							<asp:listitem value="7:00 AM" Text="7:00 AM" />
							<asp:listitem value="7:30 AM" Text="7:30 AM" />
							<asp:listitem value="8:00 AM" Text="8:00 AM" />
							<asp:listitem value="8:30 AM" Text="8:30 AM" />
							<asp:listitem value="9:00 AM" Text="9:00 AM" />
							<asp:listitem value="9:30 AM" Text="9:30 AM" />
							<asp:listitem value="10:00 AM" Text="10:00 AM" />
							<asp:listitem value="10:30 AM" Text="10:30 AM" />
							<asp:listitem value="11:00 AM" Text="11:00 AM" />
							<asp:listitem value="11:30 AM" Text="11:30 AM" />
							<asp:listitem value="12:00 PM" Text="12:00 PM" />
							<asp:listitem value="12:30 PM" Text="12:30 PM" />
							<asp:listitem value="1:00 PM" Text="1:00 PM" />
							<asp:listitem value="1:30 PM" Text="1:30 PM" />
							<asp:listitem value="2:00 PM" Text="2:00 PM" />
							<asp:listitem value="2:30 PM" Text="2:30 PM" />
							<asp:listitem value="3:00 PM" Text="3:00 PM" />
							<asp:listitem value="3:30 PM" Text="3:30 PM" />
							<asp:listitem value="4:00 PM" Text="4:00 PM" />
							<asp:listitem value="4:30 PM" Text="4:30 PM" />
							<asp:listitem value="5:00 PM" Text="5:00 PM" />
							<asp:listitem value="5:30 PM" Text="5:30 PM" />
							<asp:listitem value="6:00 PM" Text="6:00 PM" />
							<asp:listitem value="6:30 PM" Text="6:30 PM" />
							<asp:listitem value="7:00 PM" Text="7:00 PM" />
							<asp:listitem value="7:30 PM" Text="7:30 PM" />
							<asp:listitem value="8:00 PM" Text="8:00 PM" />
							<asp:listitem value="8:30 PM" Text="8:30 PM" />
							<asp:listitem value="9:00 PM" Text="9:00 PM" />
							<asp:listitem value="9:30 PM" Text="9:30 PM" />
							<asp:listitem value="10:00 PM" Text="10:00 PM" />
							<asp:listitem value="10:30 PM" Text="10:30 PM" />
							<asp:listitem value="11:00 PM" Text="11:00 PM" />
							<asp:listitem value="11:30 PM" Text="11:30 PM" />
							<asp:listitem value="12:00 AM" Text="12:00 AM" />
							<asp:listitem value="12:30 AM" Text="12:30 AM" />
						</asp:dropdownlist>
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
			DeleteCommand="UPDATE RestaurantEvents SET Active=0 WHERE EventID = @EventID" 
			SelectCommand="p_gv_Events @RestID">
            <DeleteParameters>
                <asp:Parameter Name="EventID" Type="Int32" />
            </DeleteParameters>
            
			<SelectParameters>
				<asp:sessionparameter name="RestID" sessionfield="RestID" /> 
			</SelectParameters>
        </asp:SqlDataSource>
		
    </div>
    </form>
</body>
</html>