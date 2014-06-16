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
    Dim constants As New StringConstants()
    Dim restaurantMenuImageFolderPath As String
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
	Sub Page_Load(sender As Object, e As EventArgs)
        restaurantMenuImageFolderPath = "~/Restaurants/" + Session("RestName") + "/ArtWork/MenuItems/"
        Try
            Dim AvailMenuGroups As New SqlDataSource
            CreateDataSource(AvailMenuGroups, "AvailMenuGroups", "p_gv_SelectMenuItemCategories @RestID", Session("RestID"))
            Dim AvailMenuGroups2 As New SqlDataSource
            CreateDataSource(AvailMenuGroups2, "AvailMenuGroups2", "p_SelectMenuItemCategories @RestID", Session("RestID"))
            Dim AvailItemTypes2 As New SqlDataSource
            CreateDataSource(AvailItemTypes2, "AvailItemTypes2", "SELECT * FROM MenuItemTypes", Nothing)
            Dim AvailItemTypes As New SqlDataSource
            CreateDataSource(AvailItemTypes, "AvailItemTypes", "SELECT * FROM MenuItemTypes", Nothing)
            SqlDataSource1.ConnectionString = connectionObject("connectionStringApp")
            If Not IsPostBack Then
                Dim objConn As New SqlConnection(connectionObject("connectionStringApp"))
                Dim objCmd As New SqlCommand("select * from MenuMealTypes order by MealID", objConn)
                objConn.Open()
                CheckBoxList1.DataSource = objCmd.ExecuteReader(CommandBehavior.CloseConnection)
                CheckBoxList1.DataBind()

                objCmd = New SqlCommand("p_MealTypeMatrix '" & Session("RestID") & "'", objConn)
                objConn.Open()
                Dim objReader As SqlDataReader = objCmd.ExecuteReader()

                While objReader.Read()
                    Dim currentCheckBox As ListItem = CheckBoxList1.Items.FindByValue(objReader("RestaurantMealEnabled").ToString())
                    If currentCheckBox IsNot Nothing Then
                        currentCheckBox.Selected = True
                    End If
                End While
            End If
        Catch ex As Exception
            msg.Text = ex.Message
        End Try
        'Dim dirInfo As New DirectoryInfo(Server.MapPath("../ArtWork/MenuItems/"))
			'Dim fileInfo As FileInfo() = dirInfo.GetFiles("*.*", SearchOption.AllDirectories)
			'MenuArtDDL.DataSource = fileinfo
			'MenuArtDDL.DataTextField = "Name"
			'MenuArtDDL.DataValueField = "Name"
			'MenuArtDDL.DataBind()

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
    
	'Sub AddRecord_Click(s As Object, e As EventArgs)
	'	Dim strLabelText As StringBuilder = new StringBuilder()
		
    '		Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
    '      Dim objConn As New SqlConnection(connectionObject("connectionStringApp"))
	'		Dim objCmd As SQLCommand
	'		Dim sqlCmd As String

	'		Dim chkChefSpecial, chkDeal, chkChildPlate As CheckBox
	'		Dim ChefSpecial, ChildPlate As Integer
	'		chkChefSpecial = CType(Form.FindControl("chkChefSpecial"), CheckBox)
	'		chkChildPlate = CType(Form.FindControl("chkChildPlate"), CheckBox)

	'		If chkChefSpecial.Checked = True
	'			ChefSpecial = 1
	'		Else
	'			ChefSpecial = 0
	'		End If

	'		If chkChildPlate.Checked = True
	'			ChildPlate = 1
	'		Else
	'			ChildPlate = 0
	'		End If
			
	'		sqlCmd = "EXECUTE p_InsertMenuItem '" & Session("RestID") & "','" & _
	'										   Loca.selectedItem.Value & "','" & _
	'										   Category.selectedItem.Value & "', '" & _
	'										   MealType.selectedItem.Value & "', '" & _
	'										   MenuArtDDL.selectedItem.Value & "', '" & _
	'										   txtName.Text & "', '" & _
	'										   txtPrice.Text & "', '" & _
	'										   txtComboPrice.Text & "', '" & _
	'										   txtDisPrice.Text & "', '" & _
	'										   ChildPlate & "', '" & _
	'										   ItemType.selectedItem.Value & "', '" & _
	'										   ChefSpecial & "'"

	'		objCmd = New SQLCommand(sqlCmd, objConn)
	'		objConn.Open()
	'		objCmd.ExecuteNonQuery()
	'		objConn.Close()

			'Response.Redirect("Default.aspx")

	'End Sub

	Protected Sub CheckBoxList1_DataBound(sender As Object, e As EventArgs)
		Dim cbl As CheckBoxList = DirectCast(sender, CheckBoxList)
		For Each l As ListItem In cbl.Items
			If l.Text = "1" Then
				l.Selected = True
				Exit For
			End If
		Next
	End Sub

	Public Function GetDDL_Art() As DataTable
		Dim myDirInfo    As DirectoryInfo
		Dim arrFileInfo  As Array
		Dim myFileInfo   As FileInfo

		Dim filesTable   As New DataTable
		Dim myDataRow    As DataRow
		Dim myDataView   As DataView

		filesTable.Columns.Add("Name", Type.GetType("System.String"))
		myDirInfo = New DirectoryInfo(Server.MapPath(restaurantMenuImageFolderPath))
		arrFileInfo = myDirInfo.GetFiles()

		For Each myFileInfo In arrFileInfo
			myDataRow = filesTable.NewRow()
			myDataRow("Name") = myFileInfo.Name
			filesTable.Rows.Add(myDataRow)
		Next myFileInfo

		Return filesTable
	End Function

	
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
				
				Dim chkBreakfast As Integer = (CType(row.FindControl("Breakfast"),CheckBox).Checked) * -1
				Dim chkBrunch As Integer = (CType(row.FindControl("Brunch"),CheckBox).Checked) * -1
				Dim chkLunch As Integer = (CType(row.FindControl("Lunch"),CheckBox).Checked) * -1
				Dim chkSupper As Integer = (CType(row.FindControl("Supper"),CheckBox).Checked) * -1
                Dim chkDinner As Integer = (CType(row.FindControl("Dinner"), CheckBox).Checked) * -1
                Dim chkMorningTeaElevenses As Integer = (CType(row.FindControl("MorningTeaElevenses"), CheckBox).Checked) * -1
                Dim chkAfternoonTea As Integer = (CType(row.FindControl("AfternoonTea"), CheckBox).Checked) * -1
				Dim ddlMenuGroup As DropDownList = TryCast(GridView1.FooterRow.FindControl("MenuItemGroup2DDL"), DropDownList)
				Dim ddlItemImage1 As DropDownList = TryCast(GridView1.FooterRow.FindControl("ItemImage1TextBox"), DropDownList)
				Dim ddlItemImage2 As DropDownList = TryCast(GridView1.FooterRow.FindControl("ItemImage2TextBox"), DropDownList)
				Dim ddlItemImage3 As DropDownList = TryCast(GridView1.FooterRow.FindControl("ItemImage3TextBox"), DropDownList)
				Dim txtItem As TextBox = TryCast(row.FindControl("ItemTextBox"), TextBox)
				Dim txtItemDesc As TextBox = TryCast(row.FindControl("ItemDescTextBox"), TextBox)
				Dim txtItemPriceA As TextBox = TryCast(row.FindControl("ItemPriceTextBox"), TextBox)
				Dim txtDiscountPrice As TextBox = TryCast(row.FindControl("DiscountPriceTextBox"), TextBox)
				Dim ddlVeg As DropDownList = TryCast(GridView1.FooterRow.FindControl("Veg"), DropDownList)
                Dim ddlChefSpecial As DropDownList = TryCast(GridView1.FooterRow.FindControl("ChefSpecial"), DropDownList)
                Dim ddlMenuType As DropDownList = TryCast(GridView1.FooterRow.FindControl("MenuType2"), DropDownList)

                Dim cmd As New SqlCommand("p_gv_InsertMenuItemNonUS @RestID,@Breakfast,@Brunch,@Lunch,@Supper,@Dinner,@MorningTeaElevenses,@AfternoonTea,@MenuGroup,@ItemImage1,@ItemImage2,@ItemImage3,@Item,@ItemDesc,@ItemPriceA,@DiscountPrice,@Veg,@ChefSpecial,@MenuType", conn)
				cmd.Parameters.AddWithValue("RestID", Session("RestID"))
				cmd.Parameters.AddWithValue("Breakfast", chkBreakfast)
				cmd.Parameters.AddWithValue("Brunch", chkBrunch)
				cmd.Parameters.AddWithValue("Lunch", chkLunch)
				cmd.Parameters.AddWithValue("Supper", chkSupper)
                cmd.Parameters.AddWithValue("Dinner", chkDinner)
                cmd.Parameters.AddWithValue("MorningTeaElevenses", chkMorningTeaElevenses)
                cmd.Parameters.AddWithValue("AfternoonTea", chkAfternoonTea)
				cmd.Parameters.AddWithValue("MenuGroup", ddlMenuGroup.selectedItem.Value)
				cmd.Parameters.AddWithValue("ItemImage1", ddlItemImage1.selectedItem.Value)
				cmd.Parameters.AddWithValue("ItemImage2", ddlItemImage2.selectedItem.Value)
				cmd.Parameters.AddWithValue("ItemImage3", ddlItemImage3.selectedItem.Value)
				cmd.Parameters.AddWithValue("Item", txtItem.Text.Replace("&","and"))
				cmd.Parameters.AddWithValue("ItemDesc", txtItemDesc.Text.Replace("&","and"))
				cmd.Parameters.AddWithValue("ItemPriceA", txtItemPriceA.Text)
				cmd.Parameters.AddWithValue("DiscountPrice", txtDiscountPrice.Text)
				cmd.Parameters.AddWithValue("Veg", ddlVeg.selectedItem.Value)
                cmd.Parameters.AddWithValue("ChefSpecial", ddlChefSpecial.SelectedItem.Value)
                cmd.Parameters.AddWithValue("MenuType", ddlMenuType.SelectedItem.Value)
                conn.Open()
				If cmd.ExecuteNonQuery() = 1 Then
					GridView1.DataBind()
                End If
            ElseIf e.CommandName.Equals("Publish") Then
                Dim command As New SqlCommand("UPDATE dbo.MenuItems SET Active=1 WHERE MenuItemID=" + e.CommandArgument + " AND Restaurant=" + Session("RestID"), conn)
                conn.Open()
                If command.ExecuteNonQuery() = 1 Then
                    GridView1.DataBind()
                    conn.Close()
                End If
            ElseIf e.CommandName.Equals("UnPublish") Then
                Dim command As New SqlCommand("UPDATE dbo.MenuItems SET Active=0 WHERE MenuItemID=" + e.CommandArgument + " AND Restaurant=" + Session("RestID"), conn)
                conn.Open()
                If command.ExecuteNonQuery() = 1 Then
                    GridView1.DataBind()
                    conn.Close()
                End If
            End If

		Catch ex As Exception
            msg.Text = ex.Message
        Finally
            conn.Close()
        End Try
	End Sub
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us">
<head runat="server">
<title>Admin Control Panel</title>
<script type="text/javascript" src="/js/carousel/jquery-1.4.2.min.js"></script>
<link rel="stylesheet" type="text/css" href="/themes/skin2.css" />
<link rel="stylesheet" type="text/css" href="/themes/skin1.css" />
<link rel="stylesheet" type="text/css" href="/themes/bubbles.css" />
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
<form runat="server">
<ajaxToolkit:ToolkitScriptManager runat="Server" EnableScriptGlobalization="true"  EnableScriptLocalization="true" ID="ScriptManager1" />

<!--			<ul class="tabs">
				<!--<li><a href="#tab1">Add Menu Item</a></li>
				<li><a href="#tab1">Edit Menu Items</a></li>
				<!--<li><a href="#tab3">View Menu</a></li>
				<li><a href="#tab2">Settings</a></li>
			</ul>
			<div class="tab_container">
				<div id="tab1" class="tab_content">
					<h2>Meal Types</h2>
					<asp:checkboxlist id="CheckBoxList1" runat="server" DataTextField="Name" DataValueField="MealID" /><br><br>-->
					<h2>Menu Items</h2>
					<div id="container">
							<asp:label runat="server" id="msg" />
							&nbsp;&nbsp;&nbsp;&nbsp;
							<asp:GridView ID="GridView1" 
										  runat="server"
										  AutoGenerateColumns="False" 
										  DataKeyNames="MenuItemID"
										  DataSourceID="SqlDataSource1" 
										  ShowFooter="true" 
										  GridLines="None"
										  AllowPaging="True" 
										  AllowSorting="True" 
										  CssClass="mGrid"
										  PagerStyle-CssClass="pgr"
										  PageSize="5"
										  AlternatingRowStyle-CssClass="alt"
										  OnRowCommand="GridView1_RowCommand">
<AlternatingRowStyle CssClass="alt"></AlternatingRowStyle>
								<Columns>
                                    <asp:TemplateField>
                                        <EditItemTemplate>
                                        </EditItemTemplate>
					                    <ItemTemplate>
						                    <asp:LinkButton ID="Publish" CommandName='<%# Bind("Publish")%>' runat="server" CommandArgument='<%# Bind("MenuItemID")%>' Text='<%# Bind("Publish")%>'></asp:LinkButton>
                                        </ItemTemplate>
				                    </asp:TemplateField>
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
									<asp:TemplateField HeaderText="Meal Types" SortExpression="MealTypes" itemstyle-width="75px" itemstyle-wrap="true">
										<EditItemTemplate>
											<asp:CheckBox Text="Breakfast" ID="Breakfast" Runat=server Checked='<%# Bind("Breakfast")%>'/><br>
											<asp:CheckBox Text="Brunch" ID="Brunch" Runat=server Checked='<%# Bind("Brunch")%>'/><br>
											<asp:CheckBox Text="Lunch" ID="Lunch" Runat=server Checked='<%# Bind("Lunch")%>'/><br>
											<asp:CheckBox Text="Dinner" ID="Dinner" Runat=server Checked='<%# Bind("Dinner")%>'/><br>
											<asp:CheckBox Text="Supper" ID="Supper" Runat=server Checked='<%# Bind("Supper")%>'/><br />
                                            <asp:CheckBox Text="Morning Tea" ID="MorningTeaElevenses" Runat=server Checked='<%# Bind("MorningTeaElevenses")%>'/><br />
                                            <asp:CheckBox Text="Afternoon Tea" ID="AfternoonTea" Runat=server Checked='<%# Bind("AfternoonTea")%>'/>
										</EditItemTemplate>
										<ItemTemplate>
											<asp:Label ID="Label0" runat="server" Text='<%# Bind("MealTypes") %>'></asp:Label>
										</ItemTemplate>
										<FooterTemplate>
											<asp:CheckBox Text="Breakfast" ID="Breakfast" Runat=server/><br>
											<asp:CheckBox Text="Brunch" ID="Brunch" Runat=server/><br>
											<asp:CheckBox Text="Lunch" ID="Lunch" Runat=server /><br>
											<asp:CheckBox Text="Dinner" ID="Dinner" Runat=server/><br>
											<asp:CheckBox Text="Supper" ID="Supper" Runat=server/><br />
                                            <asp:CheckBox Text="Morning Tea" ID="MorningTeaElevenses" Runat=server/><br />
                                            <asp:CheckBox Text="Afternoon Tea" ID="AfternoonTea" Runat=server/>
										</FooterTemplate>                 

<ItemStyle Wrap="True" Width="75px"></ItemStyle>
									</asp:TemplateField>
									<asp:TemplateField HeaderText="Group" SortExpression="MenuGroup" itemstyle-width="50px" itemstyle-wrap="true">
										<EditItemTemplate>
											<asp:DropDownList ID="MenuGroup"
															  cssclass="input"
															  Runat="server"
															  DataSourceID="AvailMenuGroups" 
															  DataTextField="MenuItemGroup" 
															  DataValueField="MenuItemGroupID"
															  SelectedValue='<%# Bind("MenuGroup") %>'>
											</asp:DropDownList>
										</EditItemTemplate>
										<ItemTemplate>
											<asp:Label ID="Label2" runat="server" Text='<%# Bind("MenuItemGroup") %>'></asp:Label>
										</ItemTemplate>
										<FooterTemplate>
											<asp:DropDownList ID="MenuItemGroup2DDL"
															  cssclass="input"
															  Runat="server"
															  DataSourceID="AvailMenuGroups2" 
															  DataTextField="MenuItemGroup" 
															  DataValueField="MenuItemGroupID">
												<asp:ListItem Text="<Select a Menu Group>" Value="00000" />
											</asp:DropDownList>
										</FooterTemplate>

<ItemStyle Wrap="True" Width="50px"></ItemStyle>
									</asp:TemplateField>

									 <asp:TemplateField HeaderText="Image 1" SortExpression="ItemImage1">
										<EditItemTemplate>
											Img 1: <asp:DropDownList id="ItemImage1" runat="server" cssclass="input" DataSource='<%# GetDDL_Art()%>' DataTextField="Name" DataValueField ="Name" SelectedValue='<%# Bind("ItemImage1") %>'></asp:DropDownList><br>
											Img 2: <asp:DropDownList id="ItemImage2" runat="server" cssclass="input" DataSource='<%# GetDDL_Art()%>' DataTextField="Name" DataValueField ="Name" SelectedValue='<%# Bind("ItemImage2") %>'></asp:DropDownList><br>
											Img 3: <asp:DropDownList id="ItemImage3" runat="server" cssclass="input" DataSource='<%# GetDDL_Art()%>' DataTextField="Name" DataValueField ="Name" SelectedValue='<%# Bind("ItemImage3") %>'></asp:DropDownList>
										</EditItemTemplate>
										<ItemTemplate>
											Img 1: <asp:Label ID="Label4" runat="server" Text='<%# Bind("ItemImage1") %>'></asp:Label><br>
											Img 2: <asp:Label ID="Label5" runat="server" Text='<%# Bind("ItemImage2") %>'></asp:Label><br>
											Img 3: <asp:Label ID="Label6" runat="server" Text='<%# Bind("ItemImage3") %>'></asp:Label>
										</ItemTemplate>
										<FooterTemplate>
											Img 1: <a href="#" class="tt"><IMG SRC="/images/help 16x16.png" WIDTH="16" HEIGHT="16" BORDER="0" ALT=""><span class="tooltip"><span class="top"></span><span class="middle">MENU Image:<br> Remember to select an image that is 120x83 pixels!</span><span class="bottom"></span></span></a><asp:DropDownList id="ItemImage1TextBox" runat="server" cssclass="input" DataSource='<%# GetDDL_Art()%>' DataTextField="Name" DataValueField ="Name"></asp:DropDownList><br>
											Img 2: <a href="#" class="tt"><IMG SRC="/images/help 16x16.png" WIDTH="16" HEIGHT="16" BORDER="0" ALT=""><span class="tooltip"><span class="top"></span><span class="middle">ITEM Image:<br> Remember to select an image that is 320x183 pixels!</span><span class="bottom"></span></span></a><asp:DropDownList id="ItemImage2TextBox" runat="server" cssclass="input" DataSource='<%# GetDDL_Art()%>' DataTextField="Name" DataValueField ="Name"></asp:DropDownList><br>
											Img 3: <a href="#" class="tt"><IMG SRC="/images/help 16x16.png" WIDTH="16" HEIGHT="16" BORDER="0" ALT=""><span class="tooltip"><span class="top"></span><span class="middle">THUMBNAIL Image:<br> Remember to select an image that is 35x35 pixels!</span><span class="bottom"></span></span></a><asp:DropDownList id="ItemImage3TextBox" runat="server" cssclass="input" DataSource='<%# GetDDL_Art()%>' DataTextField="Name" DataValueField ="Name"></asp:DropDownList>
										</FooterTemplate>                 
									</asp:TemplateField>

									 <asp:TemplateField HeaderText="Item" SortExpression="Item" itemstyle-width="75px" itemstyle-wrap="true">
										<EditItemTemplate>
											<asp:TextBox ID="Item" runat="server" cssclass="input" Text='<%# Bind("Item") %>'></asp:TextBox>
										</EditItemTemplate>
										<ItemTemplate>
											<asp:Label ID="Label7" runat="server" Text='<%# Bind("Item") %>'></asp:Label>
										</ItemTemplate>
										<FooterTemplate>
											<asp:TextBox ID="ItemTextBox" Runat="server" TextMode="multiLine" Columns="15" Rows="5" cssclass="input"></asp:TextBox>
											<asp:RequiredFieldValidator ControlToValidate="ItemTextBox" validationgroup="NewMenuItemGroup" Text="Required" runat="server" />
										</FooterTemplate>                 

<ItemStyle Wrap="True" Width="75px"></ItemStyle>
									</asp:TemplateField>

									 <asp:TemplateField HeaderText="Item Desc" SortExpression="ItemDesc" itemstyle-width="100px" itemstyle-wrap="true">
										<EditItemTemplate>
											<asp:TextBox ID="ItemDesc" runat="server" TextMode="MultiLine" Columns="15" Rows="3" cssclass="input" Text='<%# Bind("ItemDesc") %>'></asp:TextBox>
										</EditItemTemplate>
										<ItemTemplate>
											<asp:Label ID="Label8" runat="server" Text='<%# Bind("ItemDesc") %>'></asp:Label>
										</ItemTemplate>
										<FooterTemplate>
											<asp:TextBox ID="ItemDescTextBox" Runat="server" TextMode="multiLine" Columns="15" Rows="5" cssclass="input"></asp:TextBox>
											<asp:RequiredFieldValidator ControlToValidate="ItemDescTextBox" validationgroup="NewMenuItemGroup" Text="Required" runat="server" />
										</FooterTemplate>                 

<ItemStyle Wrap="True" Width="100px"></ItemStyle>
									</asp:TemplateField>

									 <asp:TemplateField HeaderText="Price" SortExpression="ItemPriceA" ItemStyle-HorizontalAlign="Right">
										<EditItemTemplate>
											<asp:TextBox ID="ItemPriceA" runat="server" cssclass="input" Text='<%# Bind("ItemPriceA") %>' size="5"></asp:TextBox>
										</EditItemTemplate>
										<ItemTemplate>
											<asp:Label ID="Label9" runat="server" Text='<%# Bind("FmItemPrice") %>'></asp:Label>
										</ItemTemplate>
										<FooterTemplate>
											<asp:TextBox ID="ItemPriceTextBox" Runat="server" cssclass="input" size="5"></asp:TextBox>
											<asp:RequiredFieldValidator ControlToValidate="ItemPriceTextBox" validationgroup="NewMenuItemGroup" Text="Required" runat="server" />
											<asp:RegularExpressionValidator ID="regexpItemPrice" runat="server" validationgroup="NewMenuItemGroup" ErrorMessage="Numeric Value Only" ControlToValidate="ItemPriceTextBox"                   ValidationExpression="^(-)?\d+(\.\d\d)?$" />
										</FooterTemplate>                 

<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:TemplateField>

									<asp:TemplateField HeaderText="Discount Price" SortExpression="DiscountPrice" ItemStyle-HorizontalAlign="Right">
										<EditItemTemplate>
											<asp:TextBox ID="DiscountPrice" runat="server" cssclass="input" Text='<%# Bind("DiscountPrice") %>' size="5"></asp:TextBox>
										</EditItemTemplate>
										<ItemTemplate>
											<asp:Label ID="Labe20" runat="server" Text='<%# Bind("FmDiscountPrice") %>'></asp:Label>
										</ItemTemplate>
										<FooterTemplate>
											<asp:TextBox ID="DiscountPriceTextBox" Runat="server" cssclass="input" size="5"></asp:TextBox>
											<asp:RequiredFieldValidator ControlToValidate="DiscountPriceTextBox" validationgroup="NewMenuItemGroup" Text="Required" runat="server" />
											<asp:RegularExpressionValidator ID="regexpDiscountPrice" runat="server" validationgroup="NewMenuItemGroup" ErrorMessage="Numeric Value Only" ControlToValidate="DiscountPriceTextBox"                   ValidationExpression="^(-)?\d+(\.\d\d)?$" />
										</FooterTemplate>                 

<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:TemplateField>

									<asp:TemplateField HeaderText="Veg?" SortExpression="Veg" ItemStyle-HorizontalAlign="Center">
										<EditItemTemplate>
											<asp:DropDownList ID="Veg" 
															  runat="server" 
															  cssclass="input"
															  SelectedValue='<%# Bind("Veg", "{0}") %>'>
												<asp:listitem value="0" text="0" />
												<asp:listitem value="1" text="1" />
											</asp:DropDownList>
										</EditItemTemplate>
										<ItemTemplate>
											<asp:Label ID="Label13" runat="server" Text='<%# Bind("Veg") %>'></asp:Label>
										</ItemTemplate>
										<FooterTemplate>
											<asp:dropdownlist runat="server" id="Veg" cssclass="input">
												<asp:listitem value="0" text="0" />
												<asp:listitem value="1" text="1" />
											</asp:dropdownlist>
										</FooterTemplate>                 

<ItemStyle HorizontalAlign="Center"></ItemStyle>
									</asp:TemplateField>

									 <asp:TemplateField HeaderText="Chef Special?" SortExpression="ChefSpecial" ItemStyle-HorizontalAlign="Center">
										<EditItemTemplate>
											<asp:DropDownList ID="ChefSpecial" 
															  runat="server" 
															  cssclass="input"
															  SelectedValue='<%# Bind("ChefSpecial", "{0}") %>'>
												<asp:listitem value="0" text="0" />
												<asp:listitem value="1" text="1" />
											</asp:DropDownList>
										</EditItemTemplate>
										<ItemTemplate>
											<asp:Label ID="Label14" runat="server" Text='<%# Bind("ChefSpecial") %>'></asp:Label>
										</ItemTemplate>
										<FooterTemplate>
											<asp:dropdownlist runat="server" id="ChefSpecial" cssclass="input">
												<asp:listitem value="0" text="0" />
												<asp:listitem value="1" text="1" />
											</asp:dropdownlist>
										</FooterTemplate>                 

<ItemStyle HorizontalAlign="Center"></ItemStyle>
									</asp:TemplateField>

                                    <asp:TemplateField HeaderText="Menu Type" SortExpression="MenuType" ItemStyle-HorizontalAlign="Center">
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="MenuType"
															  cssclass="input"
															  Runat="server"
															  DataSourceID="AvailItemTypes2" 
                                                              DataTextField="MenuType" 
															  DataValueField="MenuTypeId"
															  SelectedValue='<%# Bind("MenuTypeId") %>'>
											</asp:DropDownList>
										</EditItemTemplate>
										<ItemTemplate>
											<asp:Label ID="Label15" runat="server" Text='<%# Bind("MenuType") %>'></asp:Label>
										</ItemTemplate>
                                        <FooterTemplate>
                                            <asp:DropDownList id="MenuType2"
															  cssclass="input"
															  Runat="server"
															  DataSourceID="AvailItemTypes" 
															  DataTextField="MenuType" 
															  DataValueField="MenuTypeId"
															  SelectedValue='<%# Bind("MenuType") %>'>
											</asp:DropDownList>
                                        </FooterTemplate>

<ItemStyle HorizontalAlign="Center"></ItemStyle>
									</asp:TemplateField>

									<asp:templatefield>                  
											<footertemplate>
												  <asp:linkbutton id="btnNew" runat="server" validationgroup="NewMenuItemGroup" commandname="New" text="Save" />
											</footertemplate>
									</asp:templatefield>
								   
								</Columns>

<PagerStyle CssClass="pgr"></PagerStyle>
							</asp:GridView>
							<asp:SqlDataSource ID="SqlDataSource1" runat="server"
								ProviderName="System.Data.SqlClient" 
								DeleteCommand="DELETE FROM [MenuItems] WHERE [MenuItemID] = @MenuItemID" 
								InsertCommand="p_gv_InsertMenuItemNonUS @RestID,@Breakfast,@Brunch,@Lunch,@Supper,@Dinner,@MenuGroup,@ItemImage1,@ItemImage2,@ItemImage3,@Item,@ItemDesc,@ItemPriceA,@DiscountPrice,@Veg,@ChefSpecial,@MorningTeaElevenses,@AfternoonTea,@MenuType"
								SelectCommand="p_gv_SelectRestaurantMenuItemsNonUS @RestID"
								UpdateCommand="p_gv_UpdateMenuItemsNonUS @MenuItemID,@Breakfast,@Brunch,@Lunch,@Supper,@Dinner,@MenuGroup,@ItemImage1,@ItemImage2,@ItemImage3,@Item,@ItemDesc,@ItemPriceA,@DiscountPrice,@Veg,@ChefSpecial,@MorningTeaElevenses,@AfternoonTea,@MenuTypeId">
								<DeleteParameters>
									<asp:Parameter Name="MenuItemID" Type="Int32" />
								</DeleteParameters>
								<UpdateParameters>
                                    <asp:Parameter Name="MenuTypeId" Type="Int32"/>
                                    <asp:Parameter Name="AfternoonTea" Type="Int32"/>
                                    <asp:Parameter Name="MorningTeaElevenses" Type="Int32"/>
                                    <asp:Parameter Name="ChefSpecial" Type="String"/>
									<asp:Parameter Name="Veg" Type="String"/>
									<asp:Parameter Name="DiscountPrice" Type="String"/>
									<asp:Parameter Name="ItemPriceA" Type="String"/>
									<asp:Parameter Name="ItemDesc" Type="String"/>
									<asp:Parameter Name="Item" Type="String"/>
									<asp:Parameter Name="ItemImage3" Type="String"/>
									<asp:Parameter Name="ItemImage2" Type="String"/>
									<asp:Parameter Name="ItemImage1" Type="String"/>
									<asp:Parameter Name="MenuGroup" Type="String"/>
                                    <asp:Parameter Name="Dinner" Type="Int32"/>
									<asp:Parameter Name="Supper" Type="Int32"/>
									<asp:Parameter Name="Lunch" Type="Int32"/>
									<asp:Parameter Name="Brunch" Type="Int32"/>
									<asp:Parameter Name="Breakfast" Type="Int32"/>
                                    <asp:Parameter Name="MenuItemID" Type="Int32" />
								</UpdateParameters>
								<InsertParameters>
                                    <asp:Parameter Name="MenuType" Type="Int32"/>
									<asp:Parameter Name="ChefSpecial" Type="String"/>
									<asp:Parameter Name="Veg" Type="String"/>
									<asp:Parameter Name="DiscountPrice" Type="String"/>
									<asp:Parameter Name="ItemPriceA" Type="String"/>
									<asp:Parameter Name="ItemDesc" Type="String"/>
									<asp:Parameter Name="Item" Type="String"/>
									<asp:Parameter Name="ItemImage3" Type="String"/>
									<asp:Parameter Name="ItemImage2" Type="String"/>
									<asp:Parameter Name="ItemImage1" Type="String"/>
									<asp:Parameter Name="MenuGroup" Type="String"/>
									<asp:Parameter Name="Dinner" Type="String"/>
									<asp:Parameter Name="Supper" Type="String"/>
									<asp:Parameter Name="Lunch" Type="String"/>
									<asp:Parameter Name="Brunch" Type="String"/>
									<asp:Parameter Name="Breakfast" Type="String"/>
                                    <asp:Parameter Name="MorningTeaElevenses" Type="String"/>
                                    <asp:Parameter Name="AfternoonTea" Type="String"/>
									<asp:sessionparameter name="RestID" sessionfield="RestID" />
								</InsertParameters>
								<SelectParameters>
									<asp:sessionparameter name="RestID" sessionfield="RestID" /> 
								</SelectParameters>
							</asp:SqlDataSource>
					   
						<!--</div>
									</div>-->
									<!--<div id="tab3" class="tab_content">
										<h2>View Menus Menu Item</h2>
										Display full menu, per meal type

									</div>-->
									<!--<div id="tab2" class="tab_content">
										<h2>Configure Menu Settings</h2>
										Meal Types that are available<br>
										
										<br>
									</div>-->
						</div>
</form>
</body>