<%@ Control Language="VB" AutoEventWireup="true" %>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>
<script runat="server">
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
	Sub Page_Load(sender As Object, e As EventArgs)
        msg.Text = " "
        CreateCategoryDataSource()
        AvailCategories.ConnectionString = connectionObject("connectionStringApp")
        SqlDataSource1.ConnectionString = connectionObject("connectionStringApp")
    End Sub
    
    Private Sub CreateCategoryDataSource()
        Dim AvailCategory As New SqlDataSource
        AvailCategory.ID = "AvailCategory"
        AvailCategory.ConnectionString = connectionObject("connectionStringApp")
        AvailCategory.SelectCommand = "p_gv_GetFAQCategory"
        Me.Page.Controls.Add(AvailCategory)
    End Sub
    
	Protected Sub SubmitButton_Click(sender As Object, e As EventArgs)
        Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
        Dim Conn As New SqlConnection(connectionObject("connectionStringApp"))
		Try
			Dim cmd As New SqlCommand("p_gv_CreateFAQ @Title,@Category,@Question,@Solution,@SortOrder", conn)
			cmd.Parameters.AddWithValue("Title", txtTitle.Text)
			cmd.Parameters.AddWithValue("Category", ddlCategory.selectedItem.Value)
			cmd.Parameters.AddWithValue("Question", txtQuestion.Text)
			cmd.Parameters.AddWithValue("Solution", txtSolution.Text)
			cmd.Parameters.AddWithValue("SortOrder", txtSortOrder.Text)
			conn.Open()
			cmd.ExecuteNonQuery()
			msg.text = "FAQ Successfully added"
			GridView1.DataBind()
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
    <br />
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
						OnClientClick="return confirm('Are you sure you want to delete this FAQ?');" />
			  </ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="FAQ ID" SortExpression="ID" itemstyle-wrap="true">
				<ItemTemplate>
					<asp:Label ID="Label1" runat="server" Text='<%# Bind("ID") %>'></asp:Label>
				</ItemTemplate>           
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Title" SortExpression="Title" itemstyle-wrap="true">
				<EditItemTemplate>
					<asp:TextBox ID="Title" runat="server" cssclass="input" Text='<%# Bind("Title") %>'></asp:TextBox>
				</EditItemTemplate>
				<ItemTemplate>
					<asp:Label ID="Label2" runat="server" Text='<%# Bind("Title") %>'></asp:Label>
				</ItemTemplate>              
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Category" SortExpression="Name" itemstyle-width="50px" itemstyle-wrap="true">
				<EditItemTemplate>
					<asp:DropDownList ID="Category"
							  cssclass="input"
							  Runat="server"
							  DataSourceID="AvailCategory" 
							  DataTextField="Name" 
							  DataValueField="ID"
							  SelectedValue='<%# Bind("Category") %>'>
					</asp:DropDownList>
				</EditItemTemplate>
				<ItemTemplate>
					<asp:Label ID="Label7" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Question" SortExpression="Question" itemstyle-wrap="true">
				<EditItemTemplate>
					<asp:TextBox ID="Question" runat="server" cssclass="input" Text='<%# Bind("Question") %>'></asp:TextBox>
				</EditItemTemplate>
				<ItemTemplate>
					<asp:Label ID="Label3" runat="server" Text='<%# Bind("Question") %>'></asp:Label>
				</ItemTemplate>                
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Solution" SortExpression="Solution" itemstyle-wrap="true">
				<EditItemTemplate>
					<asp:TextBox ID="Solution" runat="server" cssclass="input" Text='<%# Bind("Solution") %>'></asp:TextBox>
				</EditItemTemplate>
				<ItemTemplate>
					<asp:Label ID="Label4" runat="server" Text='<%# Bind("Solution") %>'></asp:Label>
				</ItemTemplate>               
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Sort Order" SortExpression="sortorder" itemstyle-wrap="true">
				<EditItemTemplate>
					<asp:TextBox ID="sortorder" runat="server" cssclass="input" Text='<%# Bind("sortorder") %>'></asp:TextBox>
				</EditItemTemplate>
				<ItemTemplate>
					<asp:Label ID="Label5" runat="server" Text='<%# Bind("sortorder") %>'></asp:Label>
				</ItemTemplate>               
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Active?" SortExpression="Active" ItemStyle-HorizontalAlign="Center">
				<EditItemTemplate>
					<asp:DropDownList ID="Active" 
							  runat="server" 
							  cssclass="input"
							  SelectedValue='<%# Bind("Active", "{0}") %>'>
						<asp:listitem value="0" text="Not-Active" />
						<asp:listitem value="1" text="Active" />
					</asp:DropDownList>
				</EditItemTemplate>
				<ItemTemplate>
					<asp:Label ID="Label16" runat="server" Text='<%# Bind("Active") %>'></asp:Label>
				</ItemTemplate>               
			</asp:TemplateField>
		</Columns>
	</asp:GridView>
	<asp:SqlDataSource ID="SqlDataSource1" 
			   runat="server" 
			   ProviderName="System.Data.SqlClient" 
			   SelectCommand="p_gv_GetFAQs_Admin"
			   UpdateCommand="p_gv_UpdateFAQs @ID,@Title,@Category,@Question,@Solution,@SortOrder,@Active"
			   DeleteCommand="p_gv_ArchiveFAQ @ID">
		<UpdateParameters>
			<asp:Parameter Name="Active" />
			<asp:Parameter Name="SortOrder" />
			<asp:Parameter Name="Solution" Type="String"/>
			<asp:Parameter Name="Question" Type="String"/>
			<asp:Parameter Name="Category"/>
			<asp:Parameter Name="Title" Type="String"/>
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
			<th align="right">Title:</th>
			<td align="left"><asp:TextBox runat="server" size="50" ID="txtTitle" cssclass="input"/></td>
		</tr>
		<tr>
			<th align="right">Category:</th>
			<td align="left">
				<asp:DropDownList ID="ddlCategory"
						  cssclass="input"
						  Runat="server"
						  DataSourceID="AvailCategories" 
						  DataTextField="Name" 
						  DataValueField="ID">
				</asp:DropDownList>
				<asp:SqlDataSource ID="AvailCategories" 
						   runat="server" 
						   SelectCommand="p_gv_GetFAQCategories">
				</asp:SqlDataSource>
			</td>
		</tr>
		<tr>
			<th align="right">Question:</th>
			<td align="left"><asp:TextBox runat="server" textmode="multiline" ID="txtQuestion" cssclass="input"/></td>
		</tr>
		<tr>
			<th align="right">Solution:</th>
			<td align="left"><asp:TextBox runat="server" textmode="multiline" ID="txtSolution" cssclass="input"/></td>
		</tr>
		<tr>
			<th align="right">Sort Order:</th>
			<td align="left"><asp:TextBox runat="server" size="5" ID="txtSortOrder" cssclass="input"/></td>
		</tr>
	</table>
	<br />
	<asp:Button id="btnSubmit" Text="Create FAQ" Runat="server" cssclass="input" onclick="SubmitButton_Click" />
</div>