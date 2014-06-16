<%@ Control Language="VB" AutoEventWireup="true" %>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>
<script runat="server">
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
    Dim applicationRootPath As String
    Dim notificationOptions As Hashtable = StringConstants.GetNotificationSetting()
    
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        msg.Text = " "
        Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
        Dim Connection As New SqlConnection(connectionObject("connectionStringApp"))
        SqlDataSource1.ConnectionString = connectionObject("connectionStringApp")
        AvailPrimaryCountry2.ConnectionString = connectionObject("connectionStringApp")
        AvailRoles.ConnectionString = connectionObject("connectionStringApp")
        applicationRootPath = Request.PhysicalApplicationPath
        
        Try
            Dim tmpNotificationList As String = ""
            Dim NotificationsEnabledLabel As String = ""
            Dim command As SqlCommand
            Dim dataReader As SqlDataReader
            command = New SqlCommand("SELECT NotificationEnabled FROM dbo.Config WHERE Restaurant = 116", Connection)
            Connection.Open()
            dataReader = command.ExecuteReader()
            While dataReader.Read()
                tmpNotificationList = dataReader("NotificationEnabled")
            End While
            tmpNotificationList = tmpNotificationList.TrimEnd(",")
            command = New SqlCommand("SELECT name FROM NotificationTypes WHERE NotificationTypeID IN (" + tmpNotificationList + ")", Connection)
            dataReader = command.ExecuteReader()
            While dataReader.Read()
                NotificationsEnabledLabel += dataReader("name") + ","
            End While
                        
        Catch ex As Exception

        End Try
    End Sub
	Protected Sub SubmitButton_Click(sender As Object, e As EventArgs)
        Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
        Dim Conn As New SqlConnection(connectionObject("connectionStringApp"))
		Try
            Dim chkBreakfast, chkBrunch, chkLunch, chkSupper, chkDinner, chkMorningTea, chkAfternoonTea As Integer
            Dim chkNotificationOptions As string = ""
			If nBreakfast.Checked Then 
				chkBreakfast = 1 
			Else 
				chkBreakfast = 0 
			End If
			If nBrunch.Checked Then 
				chkBrunch = 1 
			Else 
				chkBrunch = 0 
			End If
			If nLunch.Checked Then 
				chkLunch = 1 
			Else 
				chkLunch = 0 
			End If
			If nSupper.Checked Then 
				chkSupper = 1 
			Else 
				chkSupper = 0 
			End If
			If nDinner.Checked Then 
				chkDinner = 1 
			Else 
				chkDinner = 0 
			End If
            If nMorningTea.Checked Then
                chkMorningTea = 1
            Else
                chkMorningTea = 0
            End If
            If nAfternoonTea.Checked Then
                chkAfternoonTea = 1
            Else
                chkAfternoonTea = 0
            End If
            
            Dim txtRoles As String
            Dim i
            For i = 0 To CheckBoxList1.Items.Count - 1
                If CheckBoxList1.Items(i).Selected Then
                    txtRoles += CheckBoxList1.Items(i).Text + ","
                End If
            Next
			
            Dim cmd As New SqlCommand("p_gv_CreateRestaurant @Name,@Website,@FacebookUrl,@TwitterHandle,@PrimaryCountry,@MainEmailContact,@Breakfast,@Brunch,@Lunch,@Dinner,@Supper,@MorningTea,@AfternoonTea,@Roles", Conn)
            cmd.Parameters.AddWithValue("Name", txtName.Text)
            cmd.Parameters.AddWithValue("Website", txtWebsite.Text)
            cmd.Parameters.AddWithValue("FacebookUrl", txtFacebook.Text)
            cmd.Parameters.AddWithValue("TwitterHandle", txtTwitter.Text)
            cmd.Parameters.AddWithValue("PrimaryCountry", PrimaryCountryDDL.SelectedItem.Value)
            cmd.Parameters.AddWithValue("MainEmailContact", txtMainEmail.Text)
            cmd.Parameters.AddWithValue("Breakfast", chkBreakfast)
            cmd.Parameters.AddWithValue("Brunch", chkBrunch)
            cmd.Parameters.AddWithValue("Lunch", chkLunch)
            cmd.Parameters.AddWithValue("Dinner", chkDinner)
            cmd.Parameters.AddWithValue("Supper", chkSupper)
            cmd.Parameters.AddWithValue("MorningTea", chkMorningTea)
            cmd.Parameters.AddWithValue("AfternoonTea", chkAfternoonTea)
            cmd.Parameters.AddWithValue("Roles", txtRoles)
            Conn.Open()
            cmd.ExecuteNonQuery()
            msg.Text = "Step 1: Create Restaurant - Complete"
            GridView1.DataBind()
        Catch ex As Exception
            msg.Text = ex.Message
        Finally
            Conn.Close()
        End Try

		Try
            Dim cmd2 As New SqlCommand("p_CreateRestaurantFolders @Name,@Path", Conn)
            cmd2.Parameters.AddWithValue("Name", txtName.Text)
            cmd2.Parameters.AddWithValue("Path", applicationRootPath)
			conn.Open()
			cmd2.ExecuteNonQuery()
			msg.text = msg.text + "<br>Step 2: Create Restaurant Folder Structure - Complete"

		Catch ex As Exception
			msg.text = ex.message
		Finally
			conn.Close()
		End Try

		Try
            Dim cmd3 As New SqlCommand("p_CreateRestaurantPlaceholders @Name", Conn)
            cmd3.Parameters.AddWithValue("Name", txtName.Text)
            conn.Open()
			cmd3.ExecuteNonQuery()
			msg.text = msg.text + "<br>Step 3: Create Restaurant Placeholder Records - Complete"

		Catch ex As Exception
			msg.text = ex.message
		Finally
			conn.Close()
		End Try

		Try
            Dim cmd4 As New SqlCommand("p_CreateRestaurantEmailMsgs @Name", Conn)
            cmd4.Parameters.AddWithValue("Name", txtName.Text)
            cmd4.Parameters.AddWithValue("Path", applicationRootPath)
			conn.Open()
			cmd4.ExecuteNonQuery()
			msg.text = msg.text + "<br>Step 4: Create Restaurant Email Templates - Complete"

			txtName.Text = ""
			txtWebsite.Text = ""
			txtFacebook.Text = ""
			txtTwitter.Text = ""
			txtMainEmail.Text = ""

		Catch ex As Exception
			msg.text = ex.message
		Finally
			conn.Close()
		End Try

	End Sub
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
		.mGrid th { padding: 4px 2px; color: #fff; background: #424242 url(/images/grd_head.png) repeat-x top; border-left: solid 1px #525252; }
		.mGrid th a { color: #eeeeee; text-decoration: none; }
		.mGrid .alt { background: #fcfcfc url(/images/grd_alt.png) repeat-x top; }
		.mGrid .pgr {background: #424242 url(/images/grd_pgr.png) repeat-x top; }
		.mGrid .pgr table { margin: 5px 0; }
		.mGrid .pgr td { border-width: 0; padding: 0 6px; border-left: solid 1px #666; font-weight: bold; color: #fff; line-height: 12px; }   
		.mGrid .pgr a { color: #eeeeee; text-decoration: none; }
		.mGrid .pgr a:hover { color: #000; text-decoration: none; }
		.input {border: solid black 1px; font: 11px Tahoma;}
		.lblMoney {text-align: right;}
	</style>
<div class="adminHelp">
    <br />***NOTE: Steps for setting up a new restaurant:<br>
    <font color="red"><b>
    1. Setup new roles<br>
    2. Setup new users<br>
    3. Fill out the new restaurant form<br>
    4. Review access rules<br>
    </b></font>. Also, when adding a new restaurant, please be sure and fill out as much information as possible.
</div>
<div width="75%">
   <asp:label runat="server" id="msg" /><br>
   <asp:GridView ID="GridView1" 
		  runat="server"
		  AutoGenerateColumns="False" 
		  DataKeyNames="ID"
		  DataSourceID="SqlDataSource1" 
		  ShowFooter="false" 
		  GridLines="None"
		  AllowPaging="True" 
		  AllowSorting="True" 
		  CssClass="mGrid"
		  PageSize="15"
		  emptydatatext="There aren't any existing restaurants."
		  PagerStyle-CssClass="pgr"
		  AlternatingRowStyle-CssClass="alt">
		<Columns>
			<asp:CommandField ShowEditButton="True"/>
			<asp:TemplateField>
			  <ItemTemplate>
				<asp:Button ID="btnDel" 
						runat="server" 
						Text="Delete"
						cssclass="input"
						CommandName="Delete" 
						OnClientClick="return confirm('Are you sure you want to delete the record?');" />
			  </ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Restaurant ID" SortExpression="ID" itemstyle-wrap="true">
				<ItemTemplate>
					<asp:Label ID="Label1" runat="server" Text='<%# Bind("ID") %>'></asp:Label>
				</ItemTemplate>           
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Name" SortExpression="Name" itemstyle-wrap="true">
				<EditItemTemplate>
					<asp:TextBox ID="Name" runat="server" cssclass="input" Text='<%# Bind("Name") %>'></asp:TextBox>
				</EditItemTemplate>
				<ItemTemplate>
					<asp:Label ID="Label2" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
				</ItemTemplate>              
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Web URL" SortExpression="website" itemstyle-wrap="true">
				<EditItemTemplate>
					<asp:TextBox ID="website" runat="server" cssclass="input" Text='<%# Bind("website") %>'></asp:TextBox>
				</EditItemTemplate>
				<ItemTemplate>
					<asp:Label ID="Label3" runat="server" Text='<%# Bind("website") %>'></asp:Label>
				</ItemTemplate>                
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Facebook URL" SortExpression="facebookurl" itemstyle-wrap="true">
				<EditItemTemplate>
					<asp:TextBox ID="facebookurl" runat="server" cssclass="input" Text='<%# Bind("facebookurl") %>'></asp:TextBox>
				</EditItemTemplate>
				<ItemTemplate>
					<asp:Label ID="Label4" runat="server" Text='<%# Bind("facebookurl") %>'></asp:Label>
				</ItemTemplate>               
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Twitter Handle" SortExpression="twitterhandle" itemstyle-wrap="true">
				<EditItemTemplate>
					<asp:TextBox ID="twitterhandle" runat="server" cssclass="input" Text='<%# Bind("twitterhandle") %>'></asp:TextBox>
				</EditItemTemplate>
				<ItemTemplate>
					<asp:Label ID="Label5" runat="server" Text='<%# Bind("twitterhandle") %>'></asp:Label>
				</ItemTemplate>               
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Main Email Address" SortExpression="MainEmailContact" itemstyle-wrap="true">
				<EditItemTemplate>
					<asp:TextBox ID="MainEmailContact" runat="server" cssclass="input" Text='<%# Bind("MainEmailContact") %>'></asp:TextBox>
				</EditItemTemplate>
				<ItemTemplate>
					<asp:Label ID="Label6" runat="server" Text='<%# Bind("MainEmailContact") %>'></asp:Label>
				</ItemTemplate>               
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Enabled Meal Types" SortExpression="MealTypes" itemstyle-wrap="true">
				<EditItemTemplate>
					<asp:CheckBox Text="Breakfast" ID="Breakfast" Runat=server Checked='<%# Bind("Breakfast")%>'/><br>
					<asp:CheckBox Text="Brunch" ID="Brunch" Runat=server Checked='<%# Bind("Brunch")%>'/><br>
					<asp:CheckBox Text="Lunch" ID="Lunch" Runat=server Checked='<%# Bind("Lunch")%>'/><br>
					<asp:CheckBox Text="Dinner" ID="Dinner" Runat=server Checked='<%# Bind("Dinner")%>'/><br>
					<asp:CheckBox Text="Supper" ID="Supper" Runat=server Checked='<%# Bind("Supper")%>'/><br>
                    <asp:CheckBox Text="Morning Tea" ID="MorningTeaElevenses" Runat=server Checked='<%# Bind("MorningTeaElevenses")%>'/><br>
                    <asp:CheckBox Text="Afternoon Tea" ID="AfternoonTea" Runat=server Checked='<%# Bind("AfternoonTea")%>'/>
				</EditItemTemplate>
				<ItemTemplate>
					<asp:Label ID="Label8" runat="server" Text='<%# Bind("MealTypes") %>'></asp:Label>
				</ItemTemplate>                
			</asp:TemplateField>
            <asp:TemplateField HeaderText="" SortExpression="" itemstyle-wrap="true">
				<EditItemTemplate>
				</EditItemTemplate>
				<ItemTemplate>
                    <asp:HyperLink href='<%# Eval("ID", "RestaurantAdditionalSettings.aspx?RestId={0}")%>' runat="server">Additional Settings</asp:HyperLink>
				</ItemTemplate>                
			</asp:TemplateField>
        </Columns>
	</asp:GridView>
	<asp:SqlDataSource ID="SqlDataSource1" 
			   runat="server" 
			   ProviderName="System.Data.SqlClient" 
			   SelectCommand="p_gv_GetRestaurantsConfigs"
			   UpdateCommand="p_gv_UpdateRestaurantConfig @ID,@Name,@WebSite,@FacebookUrl,@TwitterHandle,@MainEmailContact,@Breakfast,@Brunch,@Lunch,@Dinner,@Supper,@MorningTeaElevenses,@AfternoonTea"
			   DeleteCommand="p_gv_DeleteRestaurantConfig @ID">
		<UpdateParameters>
            <asp:Parameter Name="AfternoonTea"/>
            <asp:Parameter Name="MorningTeaElevenses"/>
            <asp:Parameter Name="Supper"/>
			<asp:Parameter Name="Dinner"/>
			<asp:Parameter Name="Lunch"/>
			<asp:Parameter Name="Brunch"/>
			<asp:Parameter Name="Breakfast"/>
			<asp:Parameter Name="MainEmailContact" Type="String"/>
			<asp:Parameter Name="TwitterHandle" Type="String"/>
			<asp:Parameter Name="FacebookUrl" Type="String"/>
			<asp:Parameter Name="WebSite" Type="String"/>
			<asp:Parameter Name="Name" Type="String"/>
			<asp:Parameter Name="ID" />
		</UpdateParameters>
		<DeleteParameters>
			<asp:Parameter Name="ID" />
		</DeleteParameters>
	</asp:SqlDataSource>
</div>
<div align="center">
<br>
	<h3>Add a New Restaurant</h3>
	<table>
		<tr>
			<th align="right" valign="top">Name:</th>
			<td align="left" valign="top">
				<asp:TextBox runat="server" size="50" ID="txtName" cssclass="input"/><br>
				<asp:RequiredFieldValidator runat="server" ValidationGroup="NewRestaurant" ControlToValidate="txtName" Text="*Required"/>
			</td>
		</tr>
		<tr>
			<th align="right" valign="top">Associated Roles:</th>
			<td align="left" valign="top">
				<div style="overflow: auto;height:100px;width:268px;border: 1px solid black;">
					<asp:CheckBoxList id="CheckBoxList1" 
							  runat="server"
							  DataSourceID="AvailRoles" 
							  DataTextField="RoleName" 
							  DataValueField="RoleID">
					</asp:CheckBoxList><br>
					<asp:SqlDataSource ID="AvailRoles" 
							   runat="server" 
							   SelectCommand="p_gv_SelectRoles">
					</asp:SqlDataSource>
				</div>
			</td>
		</tr>
		<tr>
			<th align="right" valign="top">Website URL:</th>
			<td align="left" valign="top"><asp:TextBox runat="server" size="50" ID="txtWebsite" cssclass="input"/><br>
			<asp:RequiredFieldValidator runat="server" ValidationGroup="NewRestaurant" ControlToValidate="txtWebsite" Text="*Required"/><br>
			<asp:RegularExpressionValidator runat="server"  ValidationGroup="NewRestaurant"
							ControlToValidate="txtWebsite"
							ValidationExpression="(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?"
							EnableClientScript="false"
							ErrorMessage="Please enter a valid URL" />
			</td>
		</tr>
		<tr>
			<th align="right" valign="top">Facebook URL:</th>
			<td align="left" valign="top"><asp:TextBox runat="server" size="50" ID="txtFacebook" cssclass="input"/><br>
			<asp:RequiredFieldValidator runat="server" ValidationGroup="NewRestaurant" ControlToValidate="txtFacebook" Text="*Required"/><br>
			<asp:RegularExpressionValidator runat="server" ValidationGroup="NewRestaurant" 
							ControlToValidate="txtFacebook"
							ValidationExpression="http[s]?://(www|[a-zA-Z]{2}-[a-zA-Z]{2})\.facebook\.com/(pages/[a-zA-Z0-9-]+/[0-9]+|[a-zA-Z0-9-]+)[/]?$"
							EnableClientScript="false"
							ErrorMessage="Please enter a valid URL" />
			</td>
		</tr>
		<tr>
			<th align="right" valign="top">Twitter Handle:</th>
			<td align="left" valign="top"><asp:TextBox runat="server" size="50" ID="txtTwitter" cssclass="input"/><br>
			<asp:RequiredFieldValidator runat="server" ValidationGroup="NewRestaurant" ControlToValidate="txtTwitter" Text="*Required"/><br>
			<asp:RegularExpressionValidator runat="server" ValidationGroup="NewRestaurant" 
							ControlToValidate="txtTwitter"
							ValidationExpression="@([A-Za-z0-9_]+)"
							EnableClientScript="false"
							ErrorMessage="Please enter a valid twitter handle" />
			</td>
		</tr>
		<tr>
			<th align="right" valign="top">Primary Country:</th>
			<td align="left" valign="top">
				<asp:DropDownList ID="PrimaryCountryDDL"
						  cssclass="input"
						  Runat="server"
						  DataSourceID="AvailPrimaryCountry2" 
						  DataTextField="Country" 
						  DataValueField="CountryID">
					<asp:ListItem Text="<Select a Country>" Value="0" />
				</asp:DropDownList>
				<asp:RequiredFieldValidator runat="server" ValidationGroup="NewRestaurant" ControlToValidate="PrimaryCountryDDL" Text="*Required"/>
				<asp:SqlDataSource ID="AvailPrimaryCountry2" 
						   runat="server" 
						   SelectCommand="p_gv_SelectCountries">
				</asp:SqlDataSource>
			</td>
		</tr>
		<tr>
			<th align="right" valign="top">Main Email Contact:</th>
			<td align="left" valign="top"><asp:TextBox runat="server" size="50" ID="txtMainEmail" cssclass="input"/><br>
			<asp:RequiredFieldValidator runat="server" ValidationGroup="NewRestaurant" ControlToValidate="txtMainEmail" Text="*Required"/>
			<asp:RegularExpressionValidator runat="server"  ValidationGroup="NewRestaurant"
							ControlToValidate="txtMainEmail"
							ValidationExpression="^[\w-]+(\.[\w-]+)*@([a-z0-9-]+(\.[a-z0-9-]+)*?\.[a-z]{2,6}|(\d{1,3}\.){3}\d{1,3})(:\d{4})?$"
							EnableClientScript="false"
							ErrorMessage="Please enter a valid email address" />
			</td>
		</tr>
		<tr>
			<th align="right" valign="top">Enabled Meal Types:</th>
			<td align="left" valign="top">
				<div style="overflow: auto;height:100px;width:268px;border: 1px solid black;">
					<asp:CheckBox Text="Breakfast" ID="nBreakfast" Runat=server/><br>
					<asp:CheckBox Text="Brunch" ID="nBrunch" Runat=server/><br>
					<asp:CheckBox Text="Lunch" ID="nLunch" Runat=server /><br>
					<asp:CheckBox Text="Dinner" ID="nDinner" Runat=server/><br>
					<asp:CheckBox Text="Supper" ID="nSupper" Runat=server/><br />
                    <asp:CheckBox Text="Morning Tea" ID="nMorningTea" Runat=server/><br />
                    <asp:CheckBox Text="Afternoon Tea" ID="nAfternoonTea" Runat=server/>
				</div>
			</td>
		</tr>
    </table>
	<br />
	<asp:Button id="btnSubmit" Text="Create Restaurant" Runat="server" ValidationGroup="NewRestaurant" cssclass="input" onclick="SubmitButton_Click" />
</div>