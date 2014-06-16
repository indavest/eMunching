<%@ Page Language="VB" debug="true" ValidateRequest="false" %>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit.HTMLEditor" tagprefix="ajtHTML" %>
<%@ Register Assembly="FredCK.FCKeditorV2" Namespace="FredCK.FCKeditorV2" TagPrefix="FCKEditorV2" %>
<script runat="server">
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        CreateCountriesDataSource() 'This will create data source for countries dropdown list
        dsAbout.ConnectionString = connectionObject("connectionStringApp")
        'Dim dirInfo As New DirectoryInfo(Server.MapPath("../ArtWork/AppIcons/"))
        'Dim fileInfo As FileInfo() = dirInfo.GetFiles("*.*", SearchOption.AllDirectories)

        'ddlEmailLogo.DataSource = fileinfo
        'ddlEmailLogo.DataTextField = "Name"
        'ddlEmailLogo.DataValueField = "Name"
        'ddlEmailLogo.DataBind()
    End Sub

    Private Sub CreateCountriesDataSource()
        Dim dsCountries As New SqlDataSource
        dsCountries.ConnectionString = connectionObject("connectionStringApp")
        dsCountries.ID = "dsCountries"
        dsCountries.SelectCommand = "p_SelectCountries"
        Me.Page.Controls.Add(dsCountries)
    End Sub
    
    Public Function GetDDL_Art() As DataTable
        Dim myDirInfo As DirectoryInfo
        Dim arrFileInfo As Array
        Dim myFileInfo As FileInfo

        Dim filesTable As New DataTable
        Dim myDataRow As DataRow
        Dim myDataView As DataView

        filesTable.Columns.Add("Name", Type.GetType("System.String"))
        myDirInfo = New DirectoryInfo(Server.MapPath("../ArtWork/AppIcons/"))
        arrFileInfo = myDirInfo.GetFiles()

        For Each myFileInfo In arrFileInfo
            myDataRow = filesTable.NewRow()
            myDataRow("Name") = myFileInfo.Name
            filesTable.Rows.Add(myDataRow)
        Next myFileInfo

        Return filesTable
    End Function


    Public Function ConvertFormattedString(ByVal FStr As String)
        Dim ProcessedHTMLa As String
        'ProcessedHTML = Server.HtmlEncode(FStr)
        ProcessedHTMLa = Server.HtmlDecode(FStr)
        Return ProcessedHTMLa
    End Function

    Protected Sub SubmitButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
        Dim con As New SqlConnection(connectionObject("connectionStringApp"))
        Dim cmd As New SqlCommand("p_gv_UpdateAboutUs", con)
        cmd.CommandType = CommandType.StoredProcedure

        For Each dataItem As RepeaterItem In Repeater1.Items
            If dataItem.ItemType = ListItemType.Item OrElse dataItem.ItemType = ListItemType.AlternatingItem Then
				
                Dim txtWebsite As TextBox = DirectCast(dataItem.FindControl("txtWebsite"), TextBox)
                Dim txtEmail As TextBox = DirectCast(dataItem.FindControl("txtEmail"), TextBox)
                Dim txtHours As TextBox = DirectCast(dataItem.FindControl("txtHours"), TextBox)
                Dim txtFacebook As TextBox = DirectCast(dataItem.FindControl("txtFacebook"), TextBox)
                Dim txtTwitter As TextBox = DirectCast(dataItem.FindControl("txtTwitter"), TextBox)
                Dim ddlEmailLogo As DropDownList = TryCast(dataItem.FindControl("ddlEmailLogo"), DropDownList)
                Dim ddlCountries As DropDownList = TryCast(dataItem.FindControl("ddlCountries"), DropDownList)
                Dim txtAbout As FCKeditor = CType(dataItem.FindControl("CKEditor1"), FCKeditor)

                cmd.Parameters.AddWithValue("@MEC", txtEmail.Text)
                cmd.Parameters.AddWithValue("@ABT", Server.HtmlEncode(txtAbout.Value))
                cmd.Parameters.AddWithValue("@PCT", ddlCountries.SelectedItem.Value)
                cmd.Parameters.AddWithValue("@EML", ddlEmailLogo.SelectedItem.Value)
                cmd.Parameters.AddWithValue("@TWT", txtTwitter.Text)
                cmd.Parameters.AddWithValue("@FBU", txtFacebook.Text)
                cmd.Parameters.AddWithValue("@HOO", txtHours.Text)
                cmd.Parameters.AddWithValue("@Web", txtWebsite.Text)
                cmd.Parameters.AddWithValue("@RestID", Session("RestID"))

                Dim updated As Integer = 0
                Try
                    con.Open()
                    updated = cmd.ExecuteNonQuery()
                Catch ex As Exception
                    Response.Write(ex.Message)
                Finally
                    con.Close()
                    con.Dispose()
                End Try
            End If
        Next
    End Sub

</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us">
<head runat="server">
<title>Admin Control Panel - About</title>
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
<form runat="server">
<ajaxToolkit:ToolkitScriptManager runat="Server" EnableScriptGlobalization="true"  EnableScriptLocalization="true" ID="ScriptManager1" />
	<center>
	<asp:Repeater id=Repeater1 runat="server" DataSourceID="dsAbout">
		<HeaderTemplate>
			<table cellspacing="5" cellpadding="10" border="0" align="center">
		</HeaderTemplate>
		<ItemTemplate>
				<tr>
					<th>Restaurant History: </th>
					<td><FCKEditorV2:FCKEditor ID="CKEditor1" runat="server" basePath="fckeditor/" ToolBarSet="Basic" Height="450" Width="700" Value='<%# ConvertFormattedString(Eval("AboutUs")) %>' /></td>
				</tr>
				<tr>
					<th>Website URL:</th>
					<td><asp:TextBox runat="server" ID="txtWebsite" size="50" cssclass="input" text='<%# Eval("WebSite") %>'/></td>
				</tr>
				<tr>
					<th>Main Contact Email Address:</th>
					<td><asp:TextBox runat="server" ID="txtEmail" size="50" cssclass="input" text='<%# Eval("MainEmailContact") %>'/></td>
				</tr>
				<tr>
					<th>Hours of Operation:</th>
					<td><asp:TextBox runat="server" ID="txtHours" size="50" cssclass="input" text='<%# Eval("HoursOfOperation") %>'/></td>
				</tr>
				<tr>
					<th>Facebook URL:</th>
					<td><asp:TextBox runat="server" ID="txtFacebook" size="50" cssclass="input" text='<%# Eval("FacebookUrl") %>'/></td>
				</tr>
				<tr>
					<th>Twitter Handle:</th>
					<td><asp:TextBox runat="server" ID="txtTwitter" size="50" cssclass="input" text='<%# Eval("TwitterHandle") %>'/></td>
				</tr>
				<tr>
					<th>Email Message Logo:</th>
					<td><asp:DropDownList id="ddlEmailLogo" runat="server" cssclass="input" DataSource='<%# GetDDL_Art()%>' DataTextField="Name" DataValueField ="Name" SelectedValue='<%# Eval("EmailLogo") %>'></asp:DropDownList></td>
				</tr>
				<tr>
					<th>Primary Country:</th>
					<td>
                        <asp:DropDownList ID="ddlCountries" cssclass="input"
										  Runat="server"
										  DataSourceID="dsCountries" 
										  DataTextField="CountryName" 
										  DataValueField="CountryID"
										  selectedvalue='<%# Eval("PrimaryCountry") %>'>
                        </asp:DropDownList>
                    </td>
				</tr>
		</ItemTemplate>
		<FooterTemplate>
			</table><br>
			<asp:Button	id="btnSubmit" Text="Save" Runat="server" cssclass="input" onclick="SubmitButton_Click" />
		</FooterTemplate>
	</asp:Repeater>
	</center>
	<asp:SqlDataSource ID="dsAbout" 
					   runat="server" 
					   ProviderName="System.Data.SqlClient" 
					   SelectCommand="p_gv_GetAbout @RestID"
				 	   >
		<SelectParameters>
			<asp:sessionparameter name="RestID" sessionfield="RestID" /> 
		</SelectParameters>
	</asp:SqlDataSource>
</form>


</body>