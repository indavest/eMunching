<%@ Page Language="VB" debug="true"%>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>
<script runat="server">
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
    
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        Dim AvailMenuGroups As New SqlDataSource
        Dim AvailMenuGroups2 As New SqlDataSource
        CreateDataSource(AvailMenuGroups, "AvailMenuGroups", "p_gv_SelectMenuItemCategories @RestID", Session("RestID"))
        CreateDataSource(AvailMenuGroups2, "AvailMenuGroups2", "p_SelectMenuItemCategories @RestID", Session("RestID"))
        SqlDataSource1.ConnectionString = connectionObject("connectionStringApp")
    End Sub
    
    Private Sub CreateDataSource(ByVal sourceName As SqlDataSource, ByVal sourceID As String, ByVal selectCommand As String, ByVal selectParameter As Integer)
        sourceName.ID = sourceID
        sourceName.ConnectionString = connectionObject("connectionStringApp")
        sourceName.SelectCommand = selectCommand
        If Not String.IsNullOrEmpty(selectParameter) Then
            sourceName.SelectParameters.Add("RestID", selectParameter)
        End If
        Me.Page.Controls.Add(sourceName)
    End Sub
    
	Public Function GetDDL_Art() As DataTable
		Dim myDirInfo    As DirectoryInfo
		Dim arrFileInfo  As Array
		Dim myFileInfo   As FileInfo

		Dim filesTable   As New DataTable
		Dim myDataRow    As DataRow
		Dim myDataView   As DataView

		filesTable.Columns.Add("Name", Type.GetType("System.String"))
		myDirInfo = New DirectoryInfo(Server.MapPath("../ArtWork/MenuItems/"))
		arrFileInfo = myDirInfo.GetFiles()

		For Each myFileInfo In arrFileInfo
			myDataRow = filesTable.NewRow()
			myDataRow("Name") = myFileInfo.Name
			filesTable.Rows.Add(myDataRow)
		Next myFileInfo

		Return filesTable
	End Function

	
	Sub GridView1_RowCommand(sender As Object, e As GridViewCommandEventArgs)
		Dim conn As New SqlConnection(connectionObject("connectionStringApp"))
		Try
			If e.CommandName.Equals("New") Then
				Dim btnNew As LinkButton = TryCast(e.CommandSource, LinkButton)
				Dim row As GridViewRow = TryCast(btnNew.NamingContainer, GridViewRow)
				If row Is Nothing Then
					Return
				End If
				Dim txtfirst_name As TextBox = TryCast(row.FindControl("MenuGroupTextBox"), TextBox)
				Dim cmd As New SqlCommand("INSERT INTO [MenuItems] ([MenuGroup]) VALUES (@MenuGroup)", conn)
				cmd.Parameters.AddWithValue("MenuGroup", txtfirst_name.Text)
				conn.Open()
				If cmd.ExecuteNonQuery() = 1 Then
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
			background-color: #F7F7E9;
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
    <form id="form1" runat="server">
    <div id="container">
		<asp:label runat="server" id="msg" />
        &nbsp;&nbsp;&nbsp;&nbsp;
        <asp:GridView ID="GridView1" 
					  runat="server"
					  AutoGenerateColumns="False" 
					  DataKeyNames="MenuItemID"
					  DataSourceID="SqlDataSource1" 
					  ShowFooter="false" 
					  GridLines="None"
					  AllowPaging="True" 
					  AllowSorting="True" 
					  CssClass="mGrid"
					  PagerStyle-CssClass="pgr"
					  AlternatingRowStyle-CssClass="alt"
					  OnRowCommand="GridView1_RowCommand">
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
                <asp:TemplateField HeaderText="Group" SortExpression="MenuGroup" itemstyle-width="100px" itemstyle-wrap="true">
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
                </asp:TemplateField>

				 <asp:TemplateField HeaderText="Image 1" SortExpression="ItemImage1">
                    <EditItemTemplate>
						<asp:DropDownList id="ItemImage1" runat="server" cssclass="input" DataSource='<%# GetDDL_Art()%>' DataTextField="Name" DataValueField ="Name" SelectedValue='<%# Bind("ItemImage1") %>'></asp:DropDownList>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label4" runat="server" Text='<%# Bind("ItemImage1") %>'></asp:Label>
                    </ItemTemplate>
                    <FooterTemplate>
						<asp:DropDownList id="ItemImage1TextBox" runat="server" cssclass="input" DataSource='<%# GetDDL_Art()%>' DataTextField="Name" DataValueField ="Name"></asp:DropDownList>
                    </FooterTemplate>                 
                </asp:TemplateField>

				 <asp:TemplateField HeaderText="Image 2" SortExpression="ItemImage2">
                    <EditItemTemplate>
						<asp:DropDownList id="ItemImage2" runat="server" cssclass="input" DataSource='<%# GetDDL_Art()%>' DataTextField="Name" DataValueField ="Name" SelectedValue='<%# Bind("ItemImage2") %>'></asp:DropDownList>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label5" runat="server" Text='<%# Bind("ItemImage2") %>'></asp:Label>
                    </ItemTemplate>
                    <FooterTemplate>
						<asp:DropDownList id="ItemImage2TextBox" runat="server" cssclass="input" DataSource='<%# GetDDL_Art()%>' DataTextField="Name" DataValueField ="Name"></asp:DropDownList>
                    </FooterTemplate>                 
                </asp:TemplateField>

				 <asp:TemplateField HeaderText="Image 3" SortExpression="ItemImage3">
                    <EditItemTemplate>
						<asp:DropDownList id="ItemImage3" runat="server" cssclass="input" DataSource='<%# GetDDL_Art()%>' DataTextField="Name" DataValueField ="Name" SelectedValue='<%# Bind("ItemImage3") %>'></asp:DropDownList>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label6" runat="server" Text='<%# Bind("ItemImage3") %>'></asp:Label>
                    </ItemTemplate>
                    <FooterTemplate>
						<asp:DropDownList id="ItemImage3TextBox" runat="server" cssclass="input" DataSource='<%# GetDDL_Art()%>' DataTextField="Name" DataValueField ="Name"></asp:DropDownList>
                    </FooterTemplate>                 
                </asp:TemplateField>

				 <asp:TemplateField HeaderText="Item" SortExpression="Item" itemstyle-width="100px" itemstyle-wrap="true">
                    <EditItemTemplate>
                        <asp:TextBox ID="Item" runat="server" cssclass="input" Text='<%# Bind("Item") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label7" runat="server" Text='<%# Bind("Item") %>'></asp:Label>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox ID="ItemTextBox" Runat="server" cssclass="input"></asp:TextBox>
                    </FooterTemplate>                 
                </asp:TemplateField>

				 <asp:TemplateField HeaderText="Item Desc" SortExpression="ItemDesc" itemstyle-width="150px" itemstyle-wrap="true">
                    <EditItemTemplate>
                        <asp:TextBox ID="ItemDesc" runat="server" TextMode="MultiLine" Columns="25" Rows="3" cssclass="input" Text='<%# Bind("ItemDesc") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label8" runat="server" Text='<%# Bind("ItemDesc") %>'></asp:Label>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox ID="ItemDescTextBox" Runat="server" cssclass="input"></asp:TextBox>
                    </FooterTemplate>                 
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
                    </FooterTemplate>                 
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
                        <asp:dropdownlist runat="server" id="ddlVegNew" cssclass="input">
							<asp:listitem value="0" text="0" />
							<asp:listitem value="1" text="1" />
						</asp:dropdownlist>
                    </FooterTemplate>                 
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
                </asp:TemplateField>

                <asp:templatefield>                  
                        <footertemplate>
                              <asp:linkbutton id="btnNew" runat="server" commandname="New" text="Save" />
                        </footertemplate>
                </asp:templatefield>
               
            </Columns>
        </asp:GridView>
		<asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ProviderName="System.Data.SqlClient" 
			DeleteCommand="DELETE FROM [MenuItems] WHERE [MenuItemID] = @MenuItemID" 
			InsertCommand="INSERT INTO [MenuItems] ([MenuGroup], [MealType]) VALUES (@MenuGroup, @MealType)"
			SelectCommand="p_gv_SelectRestaurantMenuItems @RestID"
            UpdateCommand="p_gv_UpdateMenuItems @MenuItemID,@MenuGroup,@ItemImage1,@ItemImage2,@ItemImage3,@Item,@ItemDesc,@ItemPriceA,@ComboPrice,@DiscountPrice,@ChildsPlate,@Veg,@ChefSpecial">
            <DeleteParameters>
                <asp:Parameter Name="MenuItemID" Type="Int32" />
            </DeleteParameters>
            <UpdateParameters>
				<asp:Parameter Name="ChefSpecial" Type="String"/>
                <asp:Parameter Name="Veg" Type="String"/>
                <asp:Parameter Name="ChildsPlate" Type="String"/>
                <asp:Parameter Name="DiscountPrice" Type="String"/>
				<asp:Parameter Name="ComboPrice" Type="String"/>
				<asp:Parameter Name="ItemPriceA" Type="String"/>
				<asp:Parameter Name="ItemDesc" Type="String"/>
				<asp:Parameter Name="Item" Type="String"/>
				<asp:Parameter Name="ItemImage3" Type="String"/>
				<asp:Parameter Name="ItemImage2" Type="String"/>
                <asp:Parameter Name="ItemImage1" Type="String"/>
				<asp:Parameter Name="MenuGroup" Type="String"/>
                <asp:Parameter Name="MenuItemID" Type="Int32" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="MenuGroup" Type="String" />
                <asp:Parameter Name="MealType" Type="String" />
            </InsertParameters>
			<SelectParameters>
				<asp:sessionparameter name="RestID" sessionfield="RestID" /> 
			</SelectParameters>
        </asp:SqlDataSource>
   
    </div>
    </form>
</body>
</html>