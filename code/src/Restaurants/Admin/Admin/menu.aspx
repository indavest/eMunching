<%@ Page Language="VB" debug="true"%>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>
<script runat="server">
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
	Sub Page_Load(sender As Object, e As EventArgs)
    
		Dim dirInfo As New DirectoryInfo(Server.MapPath("../ArtWork/MenuItems/"))
		Dim fileInfo As FileInfo() = dirInfo.GetFiles("*.*", SearchOption.AllDirectories)
        AvailMenuGroups.ConnectionString = connectionObject("connectionStringApp")
		ItemImage1TextBox.DataSource = fileinfo
		ItemImage1TextBox.DataTextField = "Name"
		ItemImage1TextBox.DataValueField = "Name"
		ItemImage1TextBox.DataBind()

		ItemImage1TextBox.Items.Insert(0, New ListItem("", "/images/placeholder-thumb.png"))
		ItemImage1TextBox.SelectedIndex = 0

		ItemImage2TextBox.DataSource = fileinfo
		ItemImage2TextBox.DataTextField = "Name"
		ItemImage2TextBox.DataValueField = "Name"
		ItemImage2TextBox.DataBind()

		ItemImage2TextBox.Items.Insert(0, New ListItem("", "/images/placeholder-desc.png"))
		ItemImage2TextBox.SelectedIndex = 0

		ItemImage3TextBox.DataSource = fileinfo
		ItemImage3TextBox.DataTextField = "Name"
		ItemImage3TextBox.DataValueField = "Name"
		ItemImage3TextBox.DataBind()

		ItemImage3TextBox.Items.Insert(0, New ListItem("", "/images/placeholder-image.png"))
		ItemImage3TextBox.SelectedIndex = 0

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

	Sub ImageSwap(Sender As Object, E As EventArgs)
		imgToView1.AlternateText = ItemImage1TextBox.SelectedItem.Text
		imgToView1.ImageUrl = "../ArtWork/MenuItems/" & ItemImage1TextBox.SelectedItem.Value
	End Sub
</script>

<head>
	<style type="text/css">
		body {
			font: 0.8em/21px arial,sans-serif;
		}
		.input {
			font: 12px/21px arial,sans-serif; 
			border: 1px solid #C0C0C0;
		}
		.checkbox, .radio {
			width: 19px;
			height: 25px;
			padding: 0 5px 0 0;
			background: url(/images/checkbox.gif) no-repeat;
			display: block;
			clear: left;
			float: left;
		}
		.radio {
			background: url(/images/radio.gif) no-repeat;
		}
		.select {
			position: absolute;
			width: 158px; /* With the padding included, the width is 190 pixels: the actual width of the image. */
			height: 21px;
			padding: 0 24px 0 8px;
			color: #fff;
			font: 12px/21px arial,sans-serif;
			background: url(/images/select.gif) no-repeat;
			overflow: hidden;
		}
	</style>
	<script type="text/javascript" src="/js/custom-form-elements.js"></script>
	<script language="javascript">
		function showimage()
		{
			if (!document.images)
				return
			document.images.Image1.src='../ArtWork/MenuItems/' + document.MenuItems.ItemImage1TextBox.options[document.MenuItems.ItemImage1TextBox.selectedIndex].value
		}
	</script>
	<script>
        function showimagealt(ddl)
        {
            var img = document.getElementById("ItemImage1TextBox");
            img.src = '../ArtWork/MenuItems/' + ddl.value
        }
    </script> 
</head>
<body>
<form runat="server" name="MenuItems" ID="MenuItems">
<table cellpadding="5" cellspacing="2" border="0" width="750">
	<tr>
		<td width="150" valign="top" nowrap>Create New</td>
		<td width="150"><input class="styled" type="Radio" name="new"> Item</td>
		<td width="450" colspan="5"><input class="styled" type="radio" name="new"> Category <input class="input" type="text"></td>
	</tr>
	<tr>
		<td width="150" valign="top">Description</td>
		<td width="150" colspan="3"><textarea class="input" cols="35" rows="7"></textarea></td>
		<td width="450" colspan="3"><textarea class="input" cols="50" rows="7"></textarea></td>
	</tr>
	<tr>
		<td width="150" valign="top" nowrap>Falls Under</td>
		<td width="200"><input class="styled" type="checkbox"> Chef Specials</td>
		<td width="200" colspan="2" nowrap><input class="styled" type="checkbox"> Featured Deals</td>
		<td width="200" colspan="3"><input class="styled" type="checkbox"> None</td>
	</tr>
	<tr>
		<td valign="top" nowrap>Item Type</td>
		<td><input class="styled" type="radio"> Veg</td>
		<td colspan="5"><input class="styled" type="radio"> Non Veg</td>
	</tr>
	<tr>
		<td width="150" valign="top">Category</td>
		<td width="250" colspan="2">
			<asp:listbox ID="Category"
						 runat="server"
						 cssclass="input"
						 DataSourceID="AvailMenuGroups" 
						 DataTextField="MenuItemGroup" 
						 DataValueField="MenuItemGroupID"
						 Rows="25">
			</asp:listbox>
			<asp:SqlDataSource ID="AvailMenuGroups" 
							   runat="server" 
							   SelectCommand="p_gv_SelectMenuItemCategories @RestID">
				<SelectParameters>
					<asp:sessionparameter name="RestID" sessionfield="RestID" /> 
				</SelectParameters>
			</asp:SqlDataSource>
		</td>
		<td width="10">&nbsp;</td>
		<td width="340" align="right" colspan="2">
			<table cellspacing="1" cellpadding="2" border="0">
				<tr>
					<td align="right">
						Image Upload&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<asp:DropDownList id="ItemImage1TextBox" name="ItemImage1TextBox" runat="server" cssclass="input" OnSelectedIndexChanged="ImageSwap"></asp:DropDownList><br>
						<asp:image id="imgToView1" runat="server" />
					</td>
					<td>Thumbnail</td>
				</tr>
				<tr>
					<td align="right">
						<asp:DropDownList id="ItemImage2TextBox" runat="server" cssclass="input" DataSource='<%# GetDDL_Art()%>' DataTextField="Name" DataValueField ="Name"></asp:DropDownList><br>
						<img src="/images/placeholder-desc.png" width="120px" height="83px" border="0">
					</td>
					<td>Description</td>
				</tr>
				<tr>
					<td align="right">
						<asp:DropDownList id="ItemImage3TextBox" runat="server" cssclass="input" DataSource='<%# GetDDL_Art()%>' DataTextField="Name" DataValueField ="Name"></asp:DropDownList><br>
						<img src="/images/placeholder-image.png" width="320px" height="183px" border="0">
					</td>
					<td>Images</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="top" nowrap>Item Price</td>
		<td colspan="6"><input class="input" type="text"></td>
	</tr>
	<tr>
		<td valign="top" nowrap>Discounted Price</td>
		<td colspan="6"><input class="input" type="text"></td>
	</tr>
</table>
</form>
</body>