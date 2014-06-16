<%@ Page Language="vb" debug="true"%>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>

<script runat="server">
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
    
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        SqlDataSource1.ConnectionString = connectionObject("connectionStringApp")
        FutureResv.ConnectionString = connectionObject("connectionStringApp")
        AvailLocations.ConnectionString = connectionObject("connectionStringApp")
        AvailSlots.ConnectionString = connectionObject("connectionStringApp")
        AvailTSDate.ConnectionString = connectionObject("connectionStringApp")
    End Sub
    
	Sub AddRecord_Click(s As Object, e As EventArgs)
		Dim strConn, strSQL As String
        strConn = connectionObject("connectionStringApp")
        strSQL = "p_gv_CreateReservation"

        Using cn As New SqlConnection(strConn)
            Try
                Dim command As New SqlCommand(strSQL, cn)
                command.CommandType = CommandType.StoredProcedure

                With command
                    .Parameters.AddWithValue("@Name", NName.Text)
                    .Parameters.AddWithValue("@CallBackNumber", CBN.Text)
                    .Parameters.AddWithValue("@RestaurantID", Session("RestID"))
                    .Parameters.AddWithValue("@RestaurantLocaID", Loca.selectedItem.Value)
                    .Parameters.AddWithValue("@NumGuests", NumG.Text)
					.Parameters.AddWithValue("@TimeDate", TSDate.selectedItem.Value)
                    .Parameters.AddWithValue("@TimeSlot", TSlot.selectedItem.Value)
                End With

                cn.Open()
                command.ExecuteNonQuery()
				cn.Close()

				Response.Redirect("Default.aspx")

			Catch ex As Exception
                lblError.Text = ex.ToString
            Finally
                cn.Close()
            End Try
		End Using

	End Sub

	Protected Sub CurrentDate_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
    
    End Sub
</script>

<html>
<head>
<style type="text/css"> 
body { 
  background: white url("/images/UIPinStripe.png");
  background-repeat: repeat;
  background-position: center;
}

#NavButtons 
{          
width: 100%;          
height: 100%;          
position: fixed;          
left: 0px;
top: 0px;
z-index: -99999;
color: white;
font: 25px Palantino, Sans-Serif;font-weight: bolder; text-align:center;
-webkit-user-select: none;
-khtml-user-select: none;
-moz-user-select: none;
-o-user-select: none;
user-select: none;
}      

#NavButtons img 
{         
width:100%;         
height:100%;     
} 

 GridViewStyle
{    
    border-right: 2px solid #A7A6AA;
    border-bottom: 2px solid #A7A6AA;
    border-left: 2px solid white;
    border-top: 2px solid white;
    padding: 4px;
}

.GridViewStyle a
{
    color: #FFFFFF;
}

.GridViewHeaderStyle th
{
    border-left: 1px solid #EBE9ED;
    border-right: 1px solid #EBE9ED;
}

.GridViewHeaderStyle
{
    background-color: #5D7B9D;
    font-weight: bold;
    color: White;
	font: 25px Palantino, Sans-Serif;font-weight: bolder; text-align:center;
}

.GridViewFooterStyle
{
    background-color: #5D7B9D;
    font-weight: bold;
    color: White;
	font: 25px Palantino, Sans-Serif;font-weight: bolder; text-align:center;
}

.GridViewRowStyle
{
    background-color: #F7F6F3;
    color: #333333;
	font: 23px Palantino, Sans-Serif;font-weight: bolder; text-align:center;
}

.GridViewAlternatingRowStyle 
{
    background-color: #FFFFFF;
    color: #333333;
	font: 23px Palantino, Sans-Serif;font-weight: bolder; text-align:center;
}

.GridViewRowStyle td, .GridViewAlternatingRowStyle td
{
    border: 1px solid #EBE9ED;
}

.GridViewSelectedRowStyle
{
    background-color: #E2DED6;
    font-weight: bold;
    color: #333333;
}

.GridViewPagerStyle
{
    background-color: #284775;
    color: #FFFFFF;
}

.GridViewPagerStyle table /* to center the paging links*/
{
    margin: 0 auto 0 auto;
}

.input3
{
	font: 21px Palantino, Sans-Serif; font-weight: bolder; text-align: center; border: 3px solid black;
}

.restbl 
{
	font: 21px Palantino, Sans-Serif; font-weight: bolder; text-align: left;
}
</style>

</head>
<body>
<form runat="server">
<table cellspacing="0" cellpadding="0" border="0">
	<tr>
		<td valign="top" align="left">
			<asp:label runat="server" id="lblError" />
		</td>
		<td valign="center" align="center">
			<asp:label runat="server" id="lblSR" Text="Select a Date to view the Reservations: " cssclass="restbl" />
			<asp:DropDownList ID="CurrentDate"
							  cssclass="input3"
							  AutoPostBack="true"
							  Runat="server"
							  DataSourceID="FutureResv" 
							  DataTextField="Date" 
							  DataValueField="Date"
							  OnSelectedIndexChanged="CurrentDate_SelectedIndexChanged">
				<asp:ListItem Text="<Select a Date>" Value="00000" />
			</asp:DropDownList>
			<asp:SqlDataSource ID="FutureResv" 
							   runat="server" 
							   SelectCommand="p_FutureTwoWeeksDDL">
			</asp:SqlDataSource>
		</td>
		<td valign="top" align="right">
			<asp:LoginStatus ID="LoginStatus1" cssclass="Logout" LogoutAction="Redirect" LogoutPageUrl="/Restaurants/Default.aspx" LogoutImageUrl="~/Images/logout.png" runat="server" />
		</td>
	</tr>
	<tr>
		<td valign="top">
			<table cellspacing="0" cellpadding="0" border="0" class="restbl">
				<tr>
					<th colspan="2" align="center">Add Reservation</th>
				</tr>
				<tr>
					<th>Name</th>
					<td><asp:TextBox ID="NName" runat="server" cssclass="input3" type="text"></asp:TextBox>
				</tr>
				<tr>
					<th>Call Back Number</th>
					<td><asp:TextBox ID="CBN" runat="server" cssclass="input3" type="text"></asp:TextBox>
				</tr>
				<tr>
					<th>Restaurant Location</th>
					<td>
						<asp:DropDownList ID="Loca"
										  cssclass="input3"
										  Runat="server"
										  DataSourceID="AvailLocations" 
										  DataTextField="LName" 
										  DataValueField="LocaID">
							<asp:ListItem Text="<Select a Location>" Value="00000" />
						</asp:DropDownList>
						<asp:SqlDataSource ID="AvailLocations" 
										   runat="server" 
										   SelectCommand="SELECT DISTINCT LocaID,LName FROM v_RestaurantLocations WHERE RestaurantID=@RestId">
							<SelectParameters>
								<asp:SessionParameter Name="RestId" SessionField="RestId" />
							</SelectParameters>
						</asp:SqlDataSource>
					</td>
				</tr>
				<tr>
					<th>Number of Guests</th>
					<td><asp:TextBox ID="NumG" runat="server" cssclass="input3" type="text"></asp:TextBox>
				</tr>
				<tr>
					<th>Date</th>
					<td>
						<asp:DropDownList ID="TSDate"
										  cssclass="input3"
										  Runat="server"
										  DataSourceID="AvailTSDate" 
										  DataTextField="WholeDate" 
										  DataValueField="DDate">
							<asp:ListItem Text="<Select a Date>" Value="1900-01-01" />
						</asp:DropDownList>
						<asp:SqlDataSource ID="AvailTSDate" 
										   runat="server" 
										   SelectCommand="p_CurrentWeekDDL @RestId">
							<SelectParameters>
								<asp:SessionParameter Name="RestId" SessionField="RestId" />
							</SelectParameters>
						</asp:SqlDataSource>
					</td>
				</tr>
				<tr>
					<th>Time Slot</th>
					<td>
						<asp:DropDownList ID="TSlot"
										  cssclass="input3"
										  Runat="server"
										  DataSourceID="AvailSlots" 
										  DataTextField="TSTime" 
										  DataValueField="TSTime">
							<asp:ListItem Text="<Select a Time Slot>" Value="00:00:01" />
						</asp:DropDownList>
						<asp:SqlDataSource ID="AvailSlots" 
										   runat="server" 
										   SelectCommand="p_ReservationsTimeSlotsDDL @RestId">
							<SelectParameters>
								<asp:SessionParameter Name="RestId" SessionField="RestId" />
							</SelectParameters>
						</asp:SqlDataSource>
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<asp:Button id="btnAddRecord" runat="server" Text="Create Reservation" cssclass="input3" onClick="AddRecord_Click"/>
					</td>
				</tr>
			</table>
		</td>
		<td style="padding-left:20px;">
			<center>
			<asp:GridView	ID="GridView1" 
							AllowSorting="True" 
							AllowPaging="True" 
							runat="server"
							DataSourceID="SqlDataSource1" 
							DataKeyNames="ResId"
							AutoGenerateColumns="false" 
							SelectedIndex="0" 
							GridLines="Vertical"
							cellpadding="3"
							PageSize="50"
							CssClass="GridViewStyle"
							>
							 <Columns>
								<asp:TemplateField HeaderText="Time Slot" 
												   SortExpression="TSTime" 
												   itemstyle-verticalalign="Top" 
												   itemstyle-horizontalalign="center"
												   >
									<ItemTemplate>
										<asp:Label ID="lblTSTime" runat="server" Text='<%# Eval("TSTime") %>'></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Location" 
												   SortExpression="Loca" 
												   itemstyle-verticalalign="Top" 
												   itemstyle-horizontalalign="center"
												   >
									<ItemTemplate>
										<asp:Label ID="lblLoca" runat="server" Text='<%# Eval("Loca") %>'></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Name" 
												   SortExpression="Name" 
												   itemstyle-verticalalign="Top" 
												   itemstyle-horizontalalign="center"
												   >
									<EditItemTemplate>
										<asp:TextBox ID="Name" runat="server" cssclass="input3" Text='<%# Bind("Name") %>' type="text"></asp:TextBox>
									</EditItemTemplate>
									<ItemTemplate>
										<asp:Label ID="lblName" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Callback Number" 
												   SortExpression="CallbackNumber" 
												   itemstyle-verticalalign="Top" 
												   itemstyle-horizontalalign="center"
												   >
									<EditItemTemplate>
										<asp:TextBox ID="CallbackNumber" runat="server" cssclass="input3" Text='<%# Bind("CallbackNumber") %>' type="text"></asp:TextBox>
									</EditItemTemplate>
									<ItemTemplate>
										<asp:Label ID="lblCallbackNumber" runat="server" Text='<%# Eval("CallbackNumber") %>'></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Number of Guests" 
												   SortExpression="NumberGuests" 
												   itemstyle-verticalalign="Top" 
												   itemstyle-horizontalalign="center"
												   >
									<EditItemTemplate>
										<asp:TextBox ID="NumberGuests" runat="server" cssclass="input3" Text='<%# Bind("NumberGuests") %>' type="text"></asp:TextBox>
									</EditItemTemplate>
									<ItemTemplate>
										<asp:Label ID="lblNumberGuests" runat="server" Text='<%# Eval("NumberGuests") %>'></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="">
									<ItemTemplate>
										<asp:Button runat="server" ID="Edit" cssclass="input3" Text="Edit" CommandName="Edit" />
										<asp:Button runat="server" ID="Delete" cssclass="input3" Text="Cancel" CommandName="Delete" />
									</ItemTemplate>
									<EditItemTemplate>
										<asp:Button runat="server" ID="Update" cssclass="input3" Text="Update" CommandName="Update" />
									</EditItemTemplate>					 
								</asp:TemplateField>
							 </Columns>
							 <FooterStyle CssClass="GridViewFooterStyle" />
							 <RowStyle CssClass="GridViewRowStyle" />    
							 <PagerStyle CssClass="GridViewPagerStyle" />
							 <AlternatingRowStyle CssClass="GridViewAlternatingRowStyle" />
							 <HeaderStyle CssClass="GridViewHeaderStyle" />
							 <emptydatarowstyle BackColor="#F7F7DE"/>                    
							 <emptydatatemplate>
									No Reservations.
							 </emptydatatemplate> 
							 <PagerSettings Position="Bottom" Mode="NumericFirstLast" />
			</asp:GridView>
			</center>
			<asp:SqlDataSource ID="SqlDataSource1" 
							   runat="server" 
							   ProviderName="System.Data.SqlClient" 
							   SelectCommand="p_gv_ReservationsByDay @RestId,@CurrentDate"
							   UpdateCommand="p_gv_UpdateReservations @ResId,@Name,@CallBackNumber,@NumberGuests"
							   DeleteCommand="p_gv_CancelReservations @ResID"
							   >
							   <SelectParameters>
								<asp:ControlParameter ControlID="CurrentDate" Name="CurrentDate" PropertyName="SelectedValue" Type="String" />
								<asp:SessionParameter Name="RestId" SessionField="RestId" />
							   </SelectParameters>
							   <UpdateParameters>
								<asp:Parameter Name="ResId" Type="Int32" />
								<asp:Parameter Name="Name" Type="String" />
								<asp:Parameter Name="CallBackNumber" Type="String" />
								<asp:Parameter Name="NumberGuests" Type="String" />
							   </UpdateParameters>
							   <DeleteParameters>
								<asp:Parameter Name="ResID" Type="Int32" />
							   </DeleteParameters>
			</asp:SqlDataSource>
		</td>
	</tr>
</table>

</form>

</body>

</html>