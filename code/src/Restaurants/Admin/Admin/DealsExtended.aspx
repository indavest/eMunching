<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="FredCK.FCKeditorV2" Namespace="FredCK.FCKeditorV2" TagPrefix="FCKEditorV2" %>
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DealsExtended.aspx.cs" Inherits="Restaurants_Admin_Admin_DealsExtended" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
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
<form id="Form1" runat="server">
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
                                    <FCKEditorV2:FCKEditor ID="Description" runat="server" basePath="fckeditor/" ToolBarSet="Basic" Height="450" Width="700" Value='<%# ConvertFormattedString(Eval("Description").ToString()) %>' />
                                </EditItemTemplate>
								<ItemTemplate>
									<asp:Label ID="Label8" runat="server" Text='<%# ConvertFormattedString(Eval("Description").ToString()) %>'></asp:Label>
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
                            <asp:TemplateField HeaderText="Teaser" SortExpression="Teaser" itemstyle-wrap="true">
                                <EditItemTemplate>
                                    <FCKEditorV2:FCKEditor ID="Teaser" runat="server" basePath="fckeditor/" ToolBarSet="Basic" Height="450" Width="700" Value='<%# ConvertFormattedString(Eval("Teaser").ToString()) %>' />
                                </EditItemTemplate>
								<ItemTemplate>
									<asp:Label ID="Label7" runat="server" Text='<%# ConvertFormattedString(Eval("Teaser").ToString()) %>'></asp:Label>
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
						<FCKEditorV2:FCKEditor ID="CKEditor1" runat="server" basePath="fckeditor/" ToolBarSet="Basic" Height="450" Width="700" Value='<%# ConvertFormattedString(Eval("AboutUs").ToString()) %>' />
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
                <tr>
					<th>Teaser:</th>
					<td>
						<FCKEditorV2:FCKEditor ID="FCKEditor2" runat="server" basePath="fckeditor/" ToolBarSet="Basic" Height="450" Width="700" Value='<%# ConvertFormattedString(Eval("Teaser").ToString()) %>' />
					</td>
				</tr>
			</table>
			<br />
			<asp:Button	id="btnSubmit" Text="Create Deal" Runat="server" cssclass="input" onclick="SubmitButton_Click" />
</form>


</body>
</html>
