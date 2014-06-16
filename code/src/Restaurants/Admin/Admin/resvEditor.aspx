<%@ Page Language="VB" debug="true"%>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>
<%@ Import Namespace="Utilities" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<script runat="server">
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
    
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        Dim AvailRestLocas As New SqlDataSource
        Dim AvailUsers As New SqlDataSource
        CreateDataSource(AvailRestLocas, "AvailRestLocas", "p_SelectRestaurantLocations @RestID", Session("RestID"))
        CreateDataSource(AvailUsers, "AvailUsers", "p_gv_SelectRestaurantUsers @RestID", Session("RestID"))
        SqlDataSource1.ConnectionString = connectionObject("connectionStringApp")
    End Sub
    
    Private Sub CreateDataSource(ByVal sourceName As SqlDataSource, ByVal sourceID As String, ByVal selectCommand As String, ByVal selectParameter As Integer)
        sourceName.ID = sourceID
        sourceName.ConnectionString = connectionObject("connectionStringApp")
        sourceName.SelectCommand = selectCommand
        If Not String.IsNullOrEmpty(selectParameter) Then
            sourceName.SelectParameters.Add("RestId", selectParameter)
        End If
        Me.Page.Controls.Add(sourceName)
    End Sub
    
	Sub GridView1_RowCommand(sender As Object, e As GridViewCommandEventArgs)
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
				Dim row As GridViewRow = TryCast(btnNoDataInsert.NamingContainer, GridViewRow)
				If row Is Nothing Then
					Return
				End If

				Dim NoDatatxtResvNameTextBox As TextBox = TryCast(GridView1.Controls(0).Controls(0).FindControl("NoDataResvNameTextBox"), TextBox)
				Dim NoDatatxtResvCallBackNumTextBox As TextBox = TryCast(GridView1.Controls(0).Controls(0).FindControl("NoDataResvCallBackNumTextBox"), TextBox)
				Dim NoDataRestLocaNameDDL As DropDownList = TryCast(GridView1.Controls(0).Controls(0).FindControl("NoDataRestLocaNameDDL"), DropDownList)
				Dim NoDataRequestedByDDL As DropDownList = TryCast(GridView1.Controls(0).Controls(0).FindControl("NoDataRequestedByDDL"), DropDownList)
				Dim NoDatatxtResvNumGuestsTextBox As TextBox = TryCast(GridView1.Controls(0).Controls(0).FindControl("NoDataResvNumGuestsTextBox"), TextBox)
				Dim NoDatatxtResvTimeslotTextBox As TextBox = TryCast(GridView1.Controls(0).Controls(0).FindControl("NoDataResvTimeslotTextBox"), TextBox)

				Dim cmd As New SqlCommand("p_Svc_CreateReservations @ResName,@CallBackNumber,@RestaurantID,@RestaurantLocaID,@UserID,@NumGuests,@TimeSlot", conn)
				cmd.Parameters.AddWithValue("ResName", NoDatatxtResvNameTextBox.Text)
				cmd.Parameters.AddWithValue("CallBackNumber", NoDatatxtResvCallBackNumTextBox.Text)
				cmd.Parameters.AddWithValue("RestaurantID", Session("RestID").ToString)
				cmd.Parameters.AddWithValue("RestaurantLocaID", NoDataRestLocaNameDDL.selectedItem.Value)
				cmd.Parameters.AddWithValue("UserID", NoDataRequestedByDDL.selectedItem.Value)
				cmd.Parameters.AddWithValue("NumGuests", NoDatatxtResvNumGuestsTextBox.Text)
				cmd.Parameters.AddWithValue("TimeSlot", NoDatatxtResvTimeslotTextBox.Text)
				conn.Open()
				If cmd.ExecuteNonQuery() = 1 Then
					GridView1.DataBind()
                End If
            ElseIf e.CommandName.Contains("Approve") Then
                Dim dataReader As SqlDataReader 
                Dim command As New SqlCommand("EXECUTE p_gv_ApproveReservation @ResvId", conn)
                command.Parameters.AddWithValue("ResvId", e.CommandArgument)
                conn.Open()
                dataReader = command.ExecuteReader()
                If (dataReader.HasRows) Then
                    While dataReader.Read()
                        Dim restName As String = Session("RestName")
                        Dim fromAdd As String = "reservations@" + restName + ".eMunching.com"
                        Dim msgBody As String = dataReader("MsgBody").Trim()
                        Dim subject As String = "RE: " + restname + " Reservation - ACCEPTED"
                        MailHelper.SendMail(dataReader("UserID"), "", subject, msgBody, fromAdd, restName)
                    End While
                    GridView1.DataBind()
                    conn.Close()
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
			/*width: 970px;*/
			/*margin: 3px auto;*/
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
                    <EditItemTemplate>
                    </EditItemTemplate>
					<ItemTemplate>
						<asp:LinkButton ID="Approve" CommandName='<%# Bind("Approve")%>' runat="server" CommandArgument='<%# Bind("ResvID")%>' Text='<%# Bind("Approve")%>'></asp:LinkButton>
                    </ItemTemplate>
				</asp:TemplateField>
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

				 <asp:TemplateField HeaderText="Resv Name" SortExpression="ResvName" itemstyle-wrap="true" itemstyle-width="75px">
                    <ItemTemplate>
                        <asp:Label ID="Label7" runat="server" Text='<%# Bind("ResvName") %>'></asp:Label>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox ID="ResvNameTextBox" Runat="server" cssclass="input" size="7"></asp:TextBox>
                    </FooterTemplate>                 
                </asp:TemplateField>

				 <asp:TemplateField HeaderText="Callback Num" SortExpression="ResvCallBackNum" itemstyle-wrap="true" itemstyle-width="75px">
                    <ItemTemplate>
                        <asp:Label ID="Label8" runat="server" Text='<%# Bind("ResvCallBackNum") %>'></asp:Label>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox ID="ResvCallBackNumTextBox" Runat="server" cssclass="input" size="10"></asp:TextBox>
                    </FooterTemplate>                 
                </asp:TemplateField>

				 <asp:TemplateField HeaderText="Location" SortExpression="RestLocaName" ItemStyle-HorizontalAlign="Center" itemstyle-width="150px">
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
					</FooterTemplate>                 
                </asp:TemplateField>

				 <asp:TemplateField HeaderText="Requested By" SortExpression="RequestedBy" ItemStyle-HorizontalAlign="Center" itemstyle-width="150px">
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
					</FooterTemplate>                 
                </asp:TemplateField>

				 <asp:TemplateField HeaderText="Num Guests" SortExpression="ResvNumGuests" ItemStyle-HorizontalAlign="Center" itemstyle-width="100px">
                    <ItemTemplate>
                        <asp:Label ID="Label11" runat="server" Text='<%# Bind("ResvNumGuests") %>'></asp:Label>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox ID="ResvNumGuestsTextBox" Runat="server" cssclass="input" size="5"></asp:TextBox>
                    </FooterTemplate>                 
                </asp:TemplateField>

				<asp:TemplateField HeaderText="Time Slot" SortExpression="ResvTimeslot" ItemStyle-HorizontalAlign="Center" itemstyle-width="150px">
                    <ItemTemplate>
                        <asp:Label ID="Label12" runat="server" Text='<%# Bind("ResvTimeslot") %>'></asp:Label>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox ID="ResvTimeslotTextBox" Runat="server" cssclass="input"></asp:TextBox><br>Format: <i>YYYY-MM-DD HH:MM PM</i>
                    </FooterTemplate>                 
                </asp:TemplateField>
				
				
                <asp:templatefield itemstyle-width="75px">                  
                        <footertemplate>
                              <asp:linkbutton id="btnNew" runat="server" commandname="New" text="Save" />
                        </footertemplate>
                </asp:templatefield>
               
            </Columns>
        </asp:GridView>
		<asp:SqlDataSource ID="SqlDataSource1" runat="server"
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
</html>