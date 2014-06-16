<%@ Page Language="VB" debug="true"%>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>
<%@ Register Assembly="FredCK.FCKeditorV2" Namespace="FredCK.FCKeditorV2" TagPrefix="FCKEditorV2" %>
<script runat="server">
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
	Sub Page_Load(sender As Object, e As EventArgs)
        Dim AvailCities As New SqlDataSource
        Dim DisplayType As New SqlDataSource 
        SqlDataSource1.ConnectionString = connectionObject("connectionStringApp")
        dsCategories.ConnectionString = connectionObject("connectionStringApp")
        CreateDataSource(AvailCities, "AvailCities", "p_gv_GetCities @RestID", Session("RestID"))
        CreateDataSource(DisplayType, "DisplayType", "SELECT Type FROM dbo.DisplaySettingOptions", vbNull)
        Dim ParentCategories As New SqlDataSource
        CreateDataSource(ParentCategories, "ParentCategories", "SELECT MenuItemGroupID,MenuItemGroup FROM MenuItemGroups WHERE Restaurant=@RestID AND Parent IS NULL", Session("RestID"))
        Dim ParentCategories1 As New SqlDataSource
        CreateDataSource(ParentCategories1, "ParentCategories1", "SELECT MenuItemGroupID,MenuItemGroup FROM MenuItemGroups WHERE Restaurant=@RestID AND Parent IS NULL", Session("RestID"))
		If Not Page.IsPostBack then

			Dim dirInfo As New DirectoryInfo(Server.MapPath("../ArtWork/CategoryIcons/"))
			Dim fileInfo As FileInfo() = dirInfo.GetFiles("*.*", SearchOption.AllDirectories)
			ddlCatImage.DataSource = fileinfo
			ddlCatImage.DataTextField = "Name"
			ddlCatImage.DataValueField = "Name"
			ddlCatImage.DataBind()

		End If

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
    
	Protected Sub SubmitButton_Click(sender As Object, e As EventArgs)

        Dim objConn As New SqlConnection(connectionObject("connectionStringApp"))
		Dim objCmd As SQLCommand
		Dim sqlCmd As String
				
		sqlCmd = "EXECUTE p_CreateCategory '" & Session("RestID") & "','" & _
											txtCategory.Text & "','" & _
											txtCatDesc.Text & "', '" & _
											ddlCatImage.selectedItem.Value & "', '" & _
											Parent1.SelectedItem.Value & "'"

		objCmd = New SQLCommand(sqlCmd, objConn)
		objConn.Open()
		objCmd.ExecuteNonQuery()
		objConn.Close()

		Response.Redirect("Settings.aspx?Atab=1")

	End Sub

	Protected Sub SubmitButton2a_Click(sender As Object, e As EventArgs)

        Dim objConn As New SqlConnection(connectionObject("connectionStringApp"))
		Dim objCmd As SQLCommand
		Dim sqlCmd As String
				
		sqlCmd = "EXECUTE p_CreateSubCategory '" & Session("RestID") & "','" & _
											txtCategory.Text & "','" & _
											txtCatDesc.Text & "'"

		objCmd = New SQLCommand(sqlCmd, objConn)
		objConn.Open()
		objCmd.ExecuteNonQuery()
		objConn.Close()

		Response.Redirect("Settings.aspx?Atab=1")

	End Sub

	Protected Sub SubmitButton2_Click(sender As Object, e As EventArgs)

        Dim objConn As New SqlConnection(connectionObject("connectionStringApp"))
		Dim objCmd As SQLCommand
		Dim sqlCmd As String
				
		sqlCmd = "EXECUTE p_CreateLocation '" & Session("RestID") & "','" & _
											txtLName.Text & "','" & _
											txtStreetAddr.Text & "','" & _
											ddlCity.selectedItem.Value & "', '" & _
											txtPhoneNumber.Text & "','" & _
											txtEmailAddr.Text & "'"

		objCmd = New SQLCommand(sqlCmd, objConn)
		objConn.Open()
		objCmd.ExecuteNonQuery()
		objConn.Close()

		Response.Redirect("Settings.aspx?Atab=0")

	End Sub

	Public Function ConvertFormattedString(FStr As String)
		Dim ProcessedHTMLa As String
		'ProcessedHTML = Server.HtmlEncode(FStr)
		ProcessedHTMLa = Server.HtmlDecode(FStr)
		Return ProcessedHTMLa
	End Function

	Public Function GetDDL_Art() As DataTable
		Dim myDirInfo    As DirectoryInfo
		Dim arrFileInfo  As Array
		Dim myFileInfo   As FileInfo

		Dim filesTable   As New DataTable
		Dim myDataRow    As DataRow
		Dim myDataView   As DataView

		filesTable.Columns.Add("Name", Type.GetType("System.String"))
		myDirInfo = New DirectoryInfo(Server.MapPath("/Restaurants/"+Session("RestName")+"/ArtWork/CategoryIcons/"))
		arrFileInfo = myDirInfo.GetFiles()

		For Each myFileInfo In arrFileInfo
			myDataRow = filesTable.NewRow()
			myDataRow("Name") = myFileInfo.Name
			filesTable.Rows.Add(myDataRow)
		Next myFileInfo

		Return filesTable
    End Function
    
    Public Sub updateCategories(ByVal sender As Object, ByVal e As GridViewUpdateEventArgs)
        Dim conn As New SqlConnection(connectionObject("connectionStringApp"))
        
        'Dim btnNew As LinkButton = TryCast(e.CommandSource, LinkButton)
        Dim row As GridViewRow = GridView2.Rows(e.RowIndex)
        Dim menuItemGroup As TextBox = TryCast(row.FindControl("MenuItemGroup"), TextBox)
        Dim menuItemGroupDesc As TextBox = TryCast(row.FindControl("MenuItemGroupDesc"), TextBox)
        Dim menuItemGroupImage As DropDownList = TryCast(row.FindControl("MenuItemGroupImage"), DropDownList)
        Dim order As TextBox = TryCast(row.FindControl("MenuGroupOrder"), TextBox)
        Dim Parent As DropDownList = TryCast(row.FindControl("Parent"), DropDownList)
        Dim menuItemGroupID As HiddenField = TryCast(row.FindControl("MenuItemGroupID"), HiddenField)
                    
        Dim command As New SqlCommand("p_gv_UpdateCategory @MenuItemGroupID,@RestID,@MenuItemGroup,@MenuItemGroupDesc,@MenuItemGroupImage,@Order,@Parent", conn)
        command.Parameters.AddWithValue("MenuItemGroupID", menuItemGroupID.Value)
        command.Parameters.AddWithValue("RestID", Session("RestID"))
        command.Parameters.AddWithValue("MenuItemGroup", menuItemGroup.Text)
        command.Parameters.AddWithValue("MenuItemGroupDesc", menuItemGroupDesc.Text)
        command.Parameters.AddWithValue("MenuItemGroupImage", menuItemGroupImage.SelectedItem.Value)
        command.Parameters.AddWithValue("Order", order.Text)
        command.Parameters.AddWithValue("Parent", Parent.SelectedItem.Value)
        conn.Open()
        If command.ExecuteNonQuery() = 1 Then
            GridView1.DataBind()
            Response.Redirect("Settings.aspx?Atab=1")
        End If
        conn.Close()
    End Sub
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us">
<head id="Head1" runat="server">
<title>Admin Control Panel</title>
<script type="text/javascript" src="/js/carousel/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/js/jquery.autocomplete.min.js"></script>
<link rel="stylesheet" type="text/css" href="/themes/skin2.css" />
<link rel="stylesheet" type="text/css" href="/themes/skin1.css" />
<link rel="stylesheet" type="text/css" href="/themes/grid.css" />
<link rel="stylesheet" type="text/css" href="/themes/tabs.css" />
<style type="text/css">
	.ac_results {
	padding: 0px;
	border: 1px solid black;
	background-color: white;
	overflow: hidden;
	z-index: 99999;
	}

	.ac_results ul {
	width: 100%;
	list-style-position: outside;
	list-style: none;
	padding: 0;
	margin: 0;
	}

	.ac_results li {
	margin: 0px;
	padding: 2px 5px;
	cursor: default;
	display: block;
	/*
	if width will be 100% horizontal scrollbar will apear
	when scroll mode will be used
	*/
	/*width: 100%;*/
	font: menu;
	font-size: 12px;
	/*
	it is very important, if line-height not setted or setted
	in relative units scroll will be broken in firefox
	*/
	line-height: 16px;
	overflow: hidden;
	}

	.ac_loading {
	background: white url('indicator.gif') right center no-repeat;
	}

	.ac_odd {
	background-color: #eee;
	}

	.ac_over {
	background-color: #0A246A;
	color: white;
	}
</style>
<script type="text/javascript">
	$(document).ready(function() {

		//Default Action
		//$(".tab_content").hide(); //Hide all content
		//$("ul.tabs li:first").addClass("active").show(); //Activate first tab
		//$(".tab_content:first").show(); //Show first tab content
		
		$(".tab_content").hide(); //Hide all content
		var activeTab = <%= Request.QueryString("Atab")%>; //0 based, so 1 = 2nd
		$("ul.tabs li").eq(activeTab).addClass("active").show();
		$(".tab_content").eq(activeTab).show();

		
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
<form id="Form1" runat="server">
			<ul class="tabs">
				<li><a href="#tab1">Restaurant Locations</a></li>
				<li><a href="#tab2">Menu Settings</a></li>
				<li><a href="#tab3">App Settings</a></li>
            </ul>
			<div class="tab_container">
				<div id="tab1" class="tab_content">
					<h2>Locations Configuration</h2>
						<asp:GridView ID="GridView1" 
									  runat="server"
									  AutoGenerateColumns="False" 
									  DataKeyNames="LocaID"
									  DataSourceID="SqlDataSource1" 
									  ShowFooter="false" 
									  GridLines="None"
									  AllowPaging="True" 
									  AllowSorting="True" 
									  CssClass="mGrid"
									  PageSize="30"
									  emptydatatext="There aren't any existing locations."
									  PagerStyle-CssClass="pgr"
									  AlternatingRowStyle-CssClass="alt"
									  >
									<Columns>
										<asp:CommandField ShowEditButton="True" ShowDeleteButton="True"/>
										
										<asp:TemplateField HeaderText="Name" SortExpression="LName" itemstyle-wrap="true">
											<EditItemTemplate>
												<asp:TextBox ID="LName" runat="server" cssclass="input" Text='<%# Bind("LName") %>'></asp:TextBox>
											</EditItemTemplate>
											<ItemTemplate>
												<asp:Label ID="Label1" runat="server" Text='<%# Bind("LName") %>'></asp:Label>
											</ItemTemplate>               
										</asp:TemplateField>

										<asp:TemplateField HeaderText="Address" SortExpression="StreetAddress" itemstyle-wrap="true">
											<EditItemTemplate>
												<asp:TextBox ID="StreetAddress" runat="server" cssclass="input" Text='<%# Bind("StreetAddress") %>'></asp:TextBox>
											</EditItemTemplate>
											<ItemTemplate>
												<asp:Label ID="Label2" runat="server" Text='<%# Bind("StreetAddress") %>'></asp:Label>
											</ItemTemplate>               
										</asp:TemplateField>

										<asp:TemplateField HeaderText="City" SortExpression="City" itemstyle-wrap="true">
											<EditItemTemplate>
												<asp:DropDownList ID="CityID"
																  cssclass="input"
																  Runat="server"
																  DataSourceID="AvailCities" 
																  DataTextField="City" 
																  DataValueField="CityID"
																  SelectedValue='<%# Bind("CityID") %>'>
												</asp:DropDownList>
											</EditItemTemplate>
											<ItemTemplate>
												<asp:Label ID="Label3" runat="server" Text='<%# Bind("City") %>'></asp:Label>
											</ItemTemplate>               
										</asp:TemplateField>

										<asp:TemplateField HeaderText="Phone" SortExpression="PhoneNumber" itemstyle-wrap="true">
											<EditItemTemplate>
												<asp:TextBox ID="PhoneNumber" runat="server" cssclass="input" Text='<%# Bind("PhoneNumber") %>'></asp:TextBox>
											</EditItemTemplate>
											<ItemTemplate>
												<asp:Label ID="Label6" runat="server" Text='<%# Bind("PhoneNumber") %>'></asp:Label>
											</ItemTemplate>               
										</asp:TemplateField>

										<asp:TemplateField HeaderText="Email" SortExpression="EmailAddress" itemstyle-wrap="true">
											<EditItemTemplate>
												<asp:TextBox ID="EmailAddress" runat="server" cssclass="input" Text='<%# Bind("EmailAddress") %>'></asp:TextBox>
											</EditItemTemplate>
											<ItemTemplate>
												<asp:Label ID="Label7" runat="server" Text='<%# Bind("EmailAddress") %>'></asp:Label>
											</ItemTemplate>               
										</asp:TemplateField>

									</Columns>
						</asp:GridView>
						<asp:SqlDataSource ID="SqlDataSource1" runat="server"
							ProviderName="System.Data.SqlClient" 
							SelectCommand="p_gv_GetRestaurantLocations @RestID"
							DeleteCommand="p_gv_DeleteRestaurantLocation @LocaID"
							UpdateCommand="p_gv_UpdateRestaurantLocations @LocaID,@LName,@CityID,@StreetAddress,@PhoneNumber,@EmailAddress">
							<DeleteParameters>
								<asp:Parameter Name="LocaID" Type="Int32" />
							</DeleteParameters>
							<UpdateParameters>
								<asp:Parameter Name="EmailAddress" Type="String"/>
								<asp:Parameter Name="PhoneNumber" Type="String"/>
								<asp:Parameter Name="StreetAddress" Type="String"/>
								<asp:Parameter Name="CityID" Type="String"/>
								<asp:Parameter Name="LName" Type="String"/>
								<asp:Parameter Name="LocaID" Type="Int32" />
							</UpdateParameters>
							<SelectParameters>
								<asp:sessionparameter name="RestID" sessionfield="RestID" /> 
							</SelectParameters>
						</asp:SqlDataSource>
						<br>
						<b>Add a New Location</b>
						<table>
							<tr>
								<th>Name:</th>
								<td><asp:TextBox runat="server" ID="txtLName" cssclass="input"/></td>
							</tr>
							<tr>
								<th>Street Address:</th>
								<td><asp:TextBox runat="server" ID="txtStreetAddr" cssclass="input"/></td>
							</tr>
							<tr>
								<th>City, State/Region, Country</th>
								<td>
									<asp:DropDownList ID="ddlCity"
													  cssclass="input"
													  Runat="server"
													  DataSourceID="AvailCities" 
													  DataTextField="City" 
													  DataValueField="CityID">
									</asp:DropDownList>
								</td>
							</tr>
							<tr>
								<th>Phone Number:</th>
								<td><asp:TextBox runat="server" ID="txtPhoneNumber" cssclass="input"/></td>
							</tr>
							<tr>
								<th>Email Address:</th>
								<td><asp:TextBox runat="server" ID="txtEmailAddr" cssclass="input"/></td>
							</tr>
						</table>
						<br />
						<asp:Button	id="btnSubmit2" Text="Create Location" Runat="server" cssclass="input" onclick="SubmitButton2_Click" />
				</div>
				<div id="tab2" class="tab_content">
					<h2>Menu Settings</h2>
						<!--<b>Meal Types</b><br />
						<i>Coming Soon</i><br />
						<br />
						<hr />-->
						<br>
						<b>Menu Categories</b><br />
						<asp:GridView ID="GridView2" 
									  runat="server"
									  AutoGenerateColumns="False" 
									  DataKeyNames="MenuItemGroupID"
									  DataSourceID="dsCategories" 
									  GridLines="None"
									  AllowPaging="True" 
									  AllowSorting="True" 
									  CssClass="mGrid"
									  PageSize="30"
									  emptydatatext="There aren't any existing categories."
									  PagerStyle-CssClass="pgr"
									  AlternatingRowStyle-CssClass="alt"
									  OnRowUpdating="updateCategories">
<AlternatingRowStyle CssClass="alt"></AlternatingRowStyle>
									<Columns>
										<asp:CommandField ShowEditButton="True" ShowDeleteButton="True"/>
										
										<asp:TemplateField HeaderText="Category" SortExpression="MenuItemGroup" itemstyle-wrap="true">
											<EditItemTemplate>
												<asp:TextBox ID="MenuItemGroup" runat="server" cssclass="input" Text='<%# Bind("MenuItemGroup") %>'></asp:TextBox>
											</EditItemTemplate>
											<ItemTemplate>
												<asp:Label ID="Label8" runat="server" Text='<%# Bind("MenuItemGroup") %>'></asp:Label>
											</ItemTemplate>               

<ItemStyle Wrap="True"></ItemStyle>
										</asp:TemplateField>

										<asp:TemplateField HeaderText="Description" SortExpression="MenuItemGroupDesc" itemstyle-wrap="true">
											<EditItemTemplate>
												<asp:TextBox ID="MenuItemGroupDesc" runat="server" TextMode="MultiLine" cssclass="input" Text='<%# Bind("MenuItemGroupDesc") %>'></asp:TextBox>
											</EditItemTemplate>
											<ItemTemplate>
												<asp:Label ID="Label9" runat="server" Text='<%# Bind("MenuItemGroupDesc") %>'></asp:Label>
											</ItemTemplate>               

<ItemStyle Wrap="True"></ItemStyle>
										</asp:TemplateField>

										<asp:TemplateField HeaderText="Thumbnail" SortExpression="MenuItemGroupImage" itemstyle-wrap="true">
											<EditItemTemplate>
												<asp:DropDownList id="MenuItemGroupImage" runat="server" cssclass="input" DataSource='<%# GetDDL_Art()%>' DataTextField="Name" DataValueField ="Name" SelectedValue='<%# Bind("MenuItemGroupImage") %>'></asp:DropDownList>
											</EditItemTemplate>
											<ItemTemplate>
												<asp:Label ID="Label10" runat="server" Text='<%# Bind("MenuItemGroupImage") %>'></asp:Label>
											</ItemTemplate>               

<ItemStyle Wrap="True"></ItemStyle>
										</asp:TemplateField>

									    <asp:TemplateField HeaderText="Order" SortExpression="Order" itemstyle-wrap="true">
                                            <EditItemTemplate>
												<asp:TextBox ID="MenuGroupOrder" runat="server" cssclass="input" Text='<%# Bind("Order") %>'></asp:TextBox>
											</EditItemTemplate>
											<ItemTemplate>
												<asp:Label ID="Label11" runat="server" Text='<%# Bind("Order") %>'></asp:Label>
											</ItemTemplate>               

<ItemStyle Wrap="True"></ItemStyle>
										</asp:TemplateField>

                                        <asp:TemplateField HeaderText="Parent" SortExpression="Parent" itemstyle-wrap="true">
                                            <EditItemTemplate>
												<asp:DropDownList ID="Parent"
													    cssclass="input"
													    Runat="server"
													    DataSourceID="ParentCategories" 
                                                        DataTextField="MenuItemGroup" 
													    DataValueField="MenuItemGroupID"
													    SelectedValue='<%# Bind("MenuItemGroupID") %>'>
								    </asp:DropDownList>
											</EditItemTemplate>
											<ItemTemplate>
												<asp:Label ID="Label12" runat="server" Text='<%# Bind("Parent") %>'></asp:Label>
											</ItemTemplate>               

<ItemStyle Wrap="True"></ItemStyle>
										</asp:TemplateField>
                                        <asp:TemplateField>
                                            <EditItemTemplate>
                                                <asp:HiddenField ID="MenuItemGroupID" runat="server" Value='<%# Bind("MenuItemGroupID") %>' />
                                            </EditItemTemplate>
                                        </asp:TemplateField>

									</Columns>

<PagerStyle CssClass="pgr"></PagerStyle>
						</asp:GridView>
						<asp:SqlDataSource ID="dsCategories" runat="server"
							ProviderName="System.Data.SqlClient" 
							SelectCommand="p_gv_GetCategories @RestID"
							DeleteCommand="p_gv_DeleteCategory @MenuItemGroupID">
							<DeleteParameters>
								<asp:Parameter Name="MenuItemGroupID" Type="Int32" />
							</DeleteParameters>
							<SelectParameters>
								<asp:sessionparameter name="RestID" sessionfield="RestID" /> 
							</SelectParameters>
						</asp:SqlDataSource>
						<br>
						<b>Add a New Category</b>
						<table>
							<tr>
								<th>Category:</th>
								<td><asp:TextBox runat="server" ID="txtCategory" cssclass="input"/></td>
							</tr>
							<tr>
								<th>Description</th>
								<td><asp:TextBox runat="server" ID="txtCatDesc" cssclass="input"/></td>
							</tr>
							<tr>
								<th>Thumbnail</th>
								<td><asp:DropDownList id="ddlCatImage" runat="server" cssclass="input" DataSource='<%# GetDDL_Art()%>' DataTextField="Name" DataValueField ="Name"></asp:DropDownList></td>
							</tr>
                            <tr>
								<th>Parent Category</th>
								<td><asp:DropDownList ID="Parent1"
													    cssclass="input"
													    Runat="server"
													    DataSourceID="ParentCategories1" 
                                                        DataTextField="MenuItemGroup" 
													    DataValueField="MenuItemGroupID">
								    </asp:DropDownList></td>
							</tr>
						</table>
						<br />
						<asp:Button	id="btnSubmit" Text="Create Category" Runat="server" cssclass="input" onclick="SubmitButton_Click" />
					<br/>
					<hr />
					
					<br>
				</div>
				<div id="tab3" class="tab_content">
					<h2>App Settings</h2>
					<iframe frameborder="0" name="ThemeiFrame2" src="slide.aspx" width="890px" height="1050px"></iframe>
					<br>
				</div>
            </div>
</form>
</body>