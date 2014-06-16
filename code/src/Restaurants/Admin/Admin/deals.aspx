<%@ Page Language="VB" debug="true" ValidateRequest="false" %>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>
<%@ Import Namespace="Utilities" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="FredCK.FCKeditorV2" Namespace="FredCK.FCKeditorV2" TagPrefix="FCKEditorV2" %>
<script runat="server">
	' OnLoad read in existing deals and display grid (page 5 only)
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
	Sub Page_Load(sender As Object, e As EventArgs)
        SqlDataSource1.ConnectionString = connectionObject("connectionStringApp")
        Dim AvailItemTypes As New SqlDataSource
        CreateDataSource(AvailItemTypes, "AvailItemTypes", "SELECT * FROM MenuItemTypes", Nothing)
        Dim AvailItemTypes2 As New SqlDataSource
        CreateDataSource(AvailItemTypes2, "AvailItemTypes2", "SELECT * FROM MenuItemTypes", Nothing)
        
    End Sub

	Protected Sub SubmitButton_Click(sender As Object, e As EventArgs)

		'Dim txtAbout As FCKeditor = CType(dataItem.FindControl("CKEditor1"), FCKeditor) 
	
		Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
        Dim objConn As New SqlConnection(connectionObject("connectionStringApp"))
		Dim objCmd As SQLCommand
		Dim sqlCmd As String
        Dim dataReader As SqlDataReader
        Dim recordInserted As Integer
				
        
        sqlCmd = "EXECUTE p_CreateDeal '" & Session("RestID") & "','" & _
                                            txtDealTitle.Text & "','" & _
                                            Server.HtmlEncode(CKEditor1.Value) & "', '" & _
                                            txtDealStartDte.Text & "', '" & _
                                            txtDealStopDte.Text & "','" & _
                                            MenuType2.SelectedValue & "'"
        

		objCmd = New SQLCommand(sqlCmd, objConn)
		objConn.Open()
        recordInserted = objCmd.ExecuteNonQuery()
        objConn.Close()

        Response.Redirect("Deals.aspx")

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

	Public Function ConvertFormattedString(FStr As String)
		Dim ProcessedHTMLa As String
		'ProcessedHTML = Server.HtmlEncode(FStr)
		ProcessedHTMLa = Server.HtmlDecode(FStr)
		Return ProcessedHTMLa
    End Function
    
    Sub GridView1_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        Dim conn As New SqlConnection(connectionObject("connectionStringApp"))
        Dim objCmd As SqlCommand
        Dim dataReader As SqlDataReader
        Try
            Dim Action As String = e.CommandName
            
            Select Case Action
                Case "Publish"
                    Dim command As New SqlCommand("UPDATE dbo.Deals SET active=1 WHERE id=" + e.CommandArgument + " AND Restaurant=" + Session("RestID"), conn)
                    conn.Open()
                    If command.ExecuteNonQuery() = 1 Then
                        GridView1.DataBind()
                        conn.Close()
						If Helper.checkNotificationsEnabledByRestByAction(Session("RestID"), 2) Then
							NotificationHelper.registerNotification(Session("RestID"), "Deal")
						End If
                        Dim RestName As String = Session("RestName")
                        Dim fromAdd As String = "Deals@" + RestName + ".emunching.com"
                        Dim subject As String = "RE: New Deal Alert from " + RestName + "!"
                        objCmd = New SqlCommand("SELECT MPU.ID,d.description FROM dbo.MobileAppUsers MPU, dbo.Deals d WHERE MPU.ID NOT LIKE '%call.in%' AND MPU.RestaurantID = " + Session("RestId") + " AND d.id=" + e.CommandArgument, conn)
                        conn.Open()
                        dataReader = objCmd.ExecuteReader()
                        
                        While dataReader.Read()
                            Dim MsgBody As String = dataReader("description").Trim()
                            MsgBody = MsgBody.Replace("&lt;", "<")
                            MsgBody = MsgBody.Replace("&gt;", ">")
                            MsgBody = MsgBody.Replace("&amp;", "&")
                            MsgBody = MsgBody.Replace("&#39;", "")
							If Helper.checkEmailEnabledByRestByAction(Session("RestID"), 2) Then
								MailHelper.SendMail(dataReader("ID"), "", subject, MsgBody, fromAdd, RestName)
							End If
                        End While
                    End If
                    
                Case "Delete"
                    Dim command As New SqlCommand("DELETE FROM dbo.RestaurantEvents WHERE EventID=" + e.CommandArgument + " AND Restaurant=" + Session("RestID"), conn)
                    conn.Open()
                    If command.ExecuteNonQuery() = 1 Then
                        GridView1.DataBind()
                    End If
                    
                
            End Select
                
            
            
        Catch ex As Exception

        End Try
    End Sub
    
    Public Sub updateRecord(ByVal sender As Object, ByVal e As GridViewUpdateEventArgs)
        Dim conn As New SqlConnection(connectionObject("connectionStringApp"))
        
        'Dim btnNew As LinkButton = TryCast(e.CommandSource, LinkButton)
        Dim row As GridViewRow = GridView1.Rows(e.RowIndex)
        Dim title As TextBox = TryCast(row.FindControl("Title"), TextBox)
        Dim description As FCKeditor = TryCast(row.FindControl("Description"), FCKeditor)
        Dim startsFrom As TextBox = TryCast(row.FindControl("StartsFrom"), TextBox)
        Dim ExpiresOn As TextBox = TryCast(row.FindControl("ExpiresOn"), TextBox)
        Dim DealType As DropDownList = TryCast(row.FindControl("MenuType"), DropDownList)
        Dim DealID As HiddenField = TryCast(row.FindControl("DealID"), HiddenField)
                    
        Dim command As New SqlCommand("p_gv_UpdateDeals @RestID,@id,@Title,@Description,@StartsFrom,@ExpiresOn,@DealType", conn)
        command.Parameters.AddWithValue("RestID", Session("RestID"))
        command.Parameters.AddWithValue("id", DealID.Value)
        command.Parameters.AddWithValue("Title", title.Text)
        command.Parameters.AddWithValue("Description", Server.HtmlEncode(description.Value))
        command.Parameters.AddWithValue("StartsFrom", startsFrom.Text)
        command.Parameters.AddWithValue("ExpiresOn", ExpiresOn.Text)
        command.Parameters.AddWithValue("DealType", DealType.SelectedItem.Value)
        conn.Open()
        If command.ExecuteNonQuery() = 1 Then
            GridView1.DataBind()
            Response.Redirect("Deals.aspx")
        End If
        conn.Close()
    End Sub
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us">
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
<form runat="server">
<ajaxToolkit:ToolkitScriptManager runat="Server" EnableScriptGlobalization="true"  EnableScriptLocalization="true" ID="ScriptManager1" />
			<h3>Existing Deals</h3>
			<asp:GridView ID="GridView1" 
						  runat="server"
						  AutoGenerateColumns="False" 
						  DataKeyNames="id"
						  DataSourceID="SqlDataSource1" 
						  ShowFooter="false" 
						  GridLines="None"
						  AllowPaging="True" 
						  AllowSorting="True" 
						  CssClass="mGrid"
						  PageSize="5"
						  emptydatatext="There aren't any existing deals."
						  PagerStyle-CssClass="pgr"
						  AlternatingRowStyle-CssClass="alt"
                          OnRowCommand="GridView1_RowCommand"
                          OnRowUpdating="updateRecord">
						<Columns>
                            <asp:TemplateField >
					            <ItemTemplate>
						            <asp:LinkButton ID="Publish" CommandName='<%# Bind("Publish")%>' runat="server" CommandArgument='<%# Bind("id")%>' Text='<%# Bind("Publish")%>'></asp:LinkButton>
						        </ItemTemplate>
				            </asp:TemplateField>
							<asp:CommandField ShowEditButton="True" ShowDeleteButton="True"/>
							
							<asp:TemplateField HeaderText="Title" SortExpression="Title" itemstyle-wrap="true">
                                <EditItemTemplate>
                                    <asp:TextBox ID="Title" runat="server" Text='<%# Bind("Title") %>'></asp:TextBox>
                                </EditItemTemplate>
								<ItemTemplate>
									<asp:Label ID="Label7" runat="server" Text='<%# Bind("Title") %>'></asp:Label>
								</ItemTemplate>               
							</asp:TemplateField>

							 <asp:TemplateField HeaderText="Description" SortExpression="Description" itemstyle-wrap="true">
                                <EditItemTemplate>
                                    <FCKEditorV2:FCKEditor ID="Description" runat="server" basePath="fckeditor/" ToolBarSet="Basic" Height="450" Width="700" Value='<%# ConvertFormattedString(Eval("Description")) %>' />
                                </EditItemTemplate>
								<ItemTemplate>
									<asp:Label ID="Label8" runat="server" Text='<%# ConvertFormattedString(Eval("Description")) %>'></asp:Label>
								</ItemTemplate>
							 </asp:TemplateField>

							<asp:TemplateField HeaderText="Starts From" SortExpression="startsFrom" ItemStyle-HorizontalAlign="Center">
                                <EditItemTemplate>
                                    <asp:TextBox ID="StartsFrom" runat="server" Text='<%# Bind("startsFrom") %>'></asp:TextBox>
                                    <asp:ImageButton runat="Server" ID="StartsFromImage" ImageUrl="/images/Calendar_scheduleHS.png" AlternateText="Click to show calendar" /><br />
						<ajaxToolkit:CalendarExtender ID="StartsFromExtender" runat="server" TargetControlID="StartsFrom" PopupButtonID="StartsFromImage" />
                                </EditItemTemplate>
								<ItemTemplate>
									<asp:Label ID="Label15" runat="server" Text='<%# Bind("startsFrom") %>'></asp:Label>
								</ItemTemplate>            
							</asp:TemplateField>

							<asp:TemplateField HeaderText="Expires On" SortExpression="ExpiresOn" ItemStyle-HorizontalAlign="Center">
                                <EditItemTemplate>
                                    <asp:TextBox ID="ExpiresOn" runat="server" Text='<%# Bind("ExpiresOn") %>'></asp:TextBox>
                                    <asp:ImageButton runat="Server" ID="ExpiresOnImage" ImageUrl="/images/Calendar_scheduleHS.png" AlternateText="Click to show calendar" /><br />
						<ajaxToolkit:CalendarExtender ID="ExpiresOnExtender" runat="server" TargetControlID="ExpiresOn" PopupButtonID="ExpiresOnImage" />
                                </EditItemTemplate>
								<ItemTemplate>
									<asp:Label ID="Label14" runat="server" Text='<%# Bind("ExpiresOn") %>'></asp:Label>
								</ItemTemplate>            
							</asp:TemplateField>
                            
                            <asp:TemplateField HeaderText="Deal Type" SortExpression="DealType" ItemStyle-HorizontalAlign="Center">
                                <EditItemTemplate>
                                    <asp:DropDownList ID="MenuType"
													    cssclass="input"
													    Runat="server"
													    DataSourceID="AvailItemTypes2" 
                                                        DataTextField="MenuType" 
													    DataValueField="MenuTypeId"
													    SelectedValue='<%# Bind("DealTypeId") %>'>
								    </asp:DropDownList>
                                </EditItemTemplate>
								<ItemTemplate>
									<asp:Label ID="Label19" runat="server" Text='<%# Bind("DealType") %>'></asp:Label>
								</ItemTemplate>            
							</asp:TemplateField>  
                            <asp:TemplateField>
                                <EditItemTemplate>
                                    <asp:HiddenField ID="DealID" runat="server" Value='<%# Bind("id") %>' />
                                </EditItemTemplate>
                            </asp:TemplateField>
							
						</Columns>
					</asp:GridView>
					<asp:SqlDataSource ID="SqlDataSource1" runat="server"
						ProviderName="System.Data.SqlClient" 
						SelectCommand="p_gv_GetDeals @RestID"
						DeleteCommand="p_gv_DeleteDeal @ID">
						<SelectParameters>
							<asp:sessionparameter name="RestID" sessionfield="RestID" /> 
						</SelectParameters>
	                </asp:SqlDataSource>
			<br>
			<h3>Add a New Deal</h3>
			<table>
				<tr>
					<th>Title:</th>
					<td>
						<asp:TextBox runat="server" ID="txtDealTitle" cssclass="input"/>
					</td>
				</tr>
				<tr>
					<th>Deal Description</th>
					<td>
						<FCKEditorV2:FCKEditor ID="CKEditor1" runat="server" basePath="fckeditor/" ToolBarSet="Basic" Height="450" Width="700" Value='<%# ConvertFormattedString(Eval("AboutUs")) %>' />
					</td>
				</tr>
				<tr>
					<th>Starts On:</th>
					<td>
						<asp:TextBox runat="server" ID="txtDealStartDte" cssclass="input"/>
						<asp:ImageButton runat="Server" ID="txtDealStartDteImage" ImageUrl="/images/Calendar_scheduleHS.png" AlternateText="Click to show calendar" /><br />
						<ajaxToolkit:CalendarExtender ID="txtDealStartDteExtender" runat="server" TargetControlID="txtDealStartDte" PopupButtonID="txtDealStartDteImage" />
					</td>
				</tr>
				<tr>
					<th>Expires On:</th>
					<td>
						<asp:TextBox runat="server" ID="txtDealStopDte"  cssclass="input"/>
						<asp:ImageButton runat="Server" ID="txtDealStopDteImage" ImageUrl="/images/Calendar_scheduleHS.png" AlternateText="Click to show calendar" /><br />
						<ajaxToolkit:CalendarExtender ID="txtDealStopDteExtender" runat="server" TargetControlID="txtDealStopDte" PopupButtonID="txtDealStopDteImage" />
					</td>
				</tr>
                <tr>
					<th>Type:</th>
					<td>
						<asp:DropDownList id="MenuType2"
											cssclass="input"
											Runat="server"
											DataSourceID="AvailItemTypes" 
											DataTextField="MenuType" 
											DataValueField="MenuTypeId"
											>
						</asp:DropDownList>
					</td>
				</tr>
			</table>
			<br />
			<asp:Button	id="btnSubmit" Text="Create Deal" Runat="server" cssclass="input" onclick="SubmitButton_Click" />
</form>


</body>