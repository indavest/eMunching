<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="FredCK.FCKeditorV2" Namespace="FredCK.FCKeditorV2" TagPrefix="FCKEditorV2" %>
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EventsExtended.aspx.cs" Inherits="Restaurants_Admin_Admin_EventsExtended" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Control Panel - Deals</title>
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
<body bgcolor="#CCCCCC">
    <form id="Form1" runat="server">
<ajaxToolkit:ToolkitScriptManager runat="Server" EnableScriptGlobalization="true"  EnableScriptLocalization="true" ID="ScriptManager1" />
			<h3>Existing Events</h3>
			<asp:GridView ID="GridView1" 
						  runat="server"
						  AutoGenerateColumns="False" 
						  DataKeyNames="EventID"
						  DataSourceID="SqlDataSource1" 
						  ShowFooter="false" 
						  GridLines="None"
						  AllowPaging="True" 
						  AllowSorting="True" 
						  CssClass="mGrid"
						  PageSize="5"
						  emptydatatext="There aren't any existing events."
						  PagerStyle-CssClass="pgr"
						  AlternatingRowStyle-CssClass="alt"
                          OnRowCommand="GridView1_RowCommand">
						<Columns>
                            <asp:TemplateField >
					            <ItemTemplate>
						            <asp:LinkButton ID="Publish" CommandName='<%# Bind("Publish")%>' runat="server" CommandArgument='<%# Bind("EventID")%>' Text='<%# Bind("Publish")%>'></asp:LinkButton>
                                    <asp:LinkButton ID="Delete" CommandName='Delete' runat="server" CommandArgument='<%# Bind("EventID")%>' Text='Delete'></asp:LinkButton>
						        </ItemTemplate>
				            </asp:TemplateField>
							
							<asp:TemplateField HeaderText="Name" SortExpression="EventName" itemstyle-wrap="true">
								<ItemTemplate>
									<asp:Label ID="Label7" runat="server" Text='<%# Bind("EventName") %>'></asp:Label>
								</ItemTemplate>               
							</asp:TemplateField>

							 <asp:TemplateField HeaderText="Desc" SortExpression="Description" itemstyle-wrap="true">
								<ItemTemplate>
									<asp:Label ID="Label8" runat="server" Text='<%# ConvertFormattedString(Eval("Description").ToString()) %>'></asp:Label>
								</ItemTemplate>
							 </asp:TemplateField>

							 <asp:TemplateField HeaderText="Location" SortExpression="LocaName" ItemStyle-HorizontalAlign="Center">
								<ItemTemplate>
									<asp:Label ID="Label9" runat="server" Text='<%# Bind("LocaName") %>'></asp:Label>
								</ItemTemplate>               
							</asp:TemplateField>

							 <asp:TemplateField HeaderText="Event Date" SortExpression="Date" ItemStyle-HorizontalAlign="Center">
								<ItemTemplate>
									<asp:Label ID="Label11" runat="server" Text='<%# Bind("Date") %>'></asp:Label>
								</ItemTemplate>                
							</asp:TemplateField>

							<asp:TemplateField HeaderText="Event Time" SortExpression="EventTime" ItemStyle-HorizontalAlign="Center">
								<ItemTemplate>
									<asp:Label ID="Label12" runat="server" Text='<%# Bind("EventTime") %>'></asp:Label>
								</ItemTemplate>                
							</asp:TemplateField>

                            <asp:TemplateField HeaderText="Teaser" SortExpression="Teaser" ItemStyle-HorizontalAlign="Center">
								<ItemTemplate>
									<asp:Label ID="Label12" runat="server" Text='<%# ConvertFormattedString(Eval("Teaser").ToString()) %>'></asp:Label>
								</ItemTemplate>                
							</asp:TemplateField>
						</Columns>
					</asp:GridView>
					<asp:SqlDataSource ID="SqlDataSource1" runat="server"
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
			<br>
			<h3>Add a New Event</h3>
			<table>
				<tr>
					<th>Event Name:</th>
					<td><asp:TextBox runat="server" ID="txtEventName" cssclass="input"/></td>
				</tr>
				<tr>
					<th>Description</th>
					<td>
						<FCKEditorV2:FCKEditor ID="CKEditor1" runat="server" basePath="fckeditor/" ToolBarSet="Basic" Height="450" Width="700" Value='<%# ConvertFormattedString(Eval("Description").ToString()) %>' />
					</td>
				</tr>
				<tr>
					<th>Location:</th>
					<td>
						<asp:DropDownList ID="ddlEventLoca"
										  cssclass="input"
										  Runat="server"
									      DataSourceID="AvailRestLocas" 
									      DataTextField="Name" 
									      DataValueField="LocaID">
							<asp:ListItem Text="<Select a Location>" Value="00000" />
						</asp:DropDownList>
						<asp:SqlDataSource ID="AvailRestLocas" 
										   runat="server" 
										   SelectCommand="p_SelectRestaurantLocations @RestID">
							<SelectParameters>
								<asp:sessionparameter name="RestID" sessionfield="RestID" /> 
							</SelectParameters>
						</asp:SqlDataSource>
					</td>
				</tr>
				<tr>
					<th>Event Date:</th>
					<td>
						<asp:TextBox runat="server" ID="txtEventDte" cssclass="input"/>
						<asp:ImageButton runat="Server" ID="txtStartDteImage" ImageUrl="/images/Calendar_scheduleHS.png" AlternateText="Click to show calendar" /><br />
						<ajaxToolkit:CalendarExtender ID="txtStartDteExtender" runat="server" TargetControlID="txtEventDte" PopupButtonID="txtStartDteImage" />
					</td>
				</tr>
				<tr>
					<th>Event Time:</th>
					<td>
						<asp:dropdownlist ID = "ddlEventTime" Runat="server" cssclass="input">
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
					</td>
				</tr>
                <tr>
					<th>Teaser:</th>
					<td>
						<FCKEditorV2:FCKEditor ID="FCKEditor2" runat="server" basePath="fckeditor/" ToolBarSet="Basic" Height="450" Width="700" Value='<%# ConvertFormattedString(Eval("Teaser").ToString()) %>' />
					</td>
				</tr>
			</table>
			<br />
			<asp:Button	id="btnSubmit" Text="Create Event" Runat="server" cssclass="input" onclick="SubmitButton_Click" />
</form>


</body>
</html>
