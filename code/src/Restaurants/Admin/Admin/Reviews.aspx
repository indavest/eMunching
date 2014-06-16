<%@ Page Language="VB" debug="true"%>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<script runat="server">
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        SqlDataSource1.ConnectionString = connectionObject("connectionStringApp")
    End Sub
    
	Sub GridView1_RowCommand(sender As Object, e As GridViewCommandEventArgs)
		Dim conn As New SqlConnection(connectionObject("connectionStringApp"))
		Try
			If e.CommandName.Equals("App") Then
				Dim btnApp As LinkButton = TryCast(e.CommandSource, LinkButton)
				Dim row As GridViewRow = TryCast(btnApp.NamingContainer, GridViewRow)
				If row Is Nothing Then
					Return
				End If
				
				Dim cmd As New SqlCommand("p_gv_ReviewApprove @ID", conn)
				cmd.Parameters.AddWithValue("ID", e.CommandArgument)
				conn.Open()
				If cmd.ExecuteNonQuery() = 1 Then
					GridView1.DataBind()
				End If
			ElseIf e.CommandName.Equals("DApp") Then
				Dim btnDApp As LinkButton = TryCast(e.CommandSource, LinkButton)
				Dim row As GridViewRow = TryCast(btnDApp.NamingContainer, GridViewRow)
				If row Is Nothing Then
					Return
				End If
				
				Dim cmd As New SqlCommand("p_gv_ReviewDisapprove @ID", conn)
				cmd.Parameters.AddWithValue("ID", e.CommandArgument)
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

	Protected Sub btn_refresh_Click(sender As Object, e As EventArgs)
		GridView1.DataBind()
	End Sub

	Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            If e.Row.Cells(6).Text = "Authorized" Then
				e.Row.Cells(6).ForeColor = Drawing.Color.White
                e.Row.Cells(6).BackColor = Drawing.Color.Green
			ElseIf e.Row.Cells(6).Text = "Not Authorized" Then
				e.Row.Cells(6).ForeColor = Drawing.Color.Yellow
                e.Row.Cells(6).BackColor = Drawing.Color.Crimson
            End If

			If e.Row.Cells(7).Text = "Reviewed" Then
				e.Row.Cells(7).ForeColor = Drawing.Color.White
                e.Row.Cells(7).BackColor = Drawing.Color.Green
			ElseIf e.Row.Cells(7).Text = "Not Reviewed" Then
				e.Row.Cells(7).ForeColor = Drawing.Color.Yellow
                e.Row.Cells(7).BackColor = Drawing.Color.Crimson
            End If
        End If
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
			width: 970px;
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
	<ajaxToolkit:ToolkitScriptManager runat="Server" EnableScriptGlobalization="true"  EnableScriptLocalization="true" ID="ScriptManager1" />
    <div id="container">
		<asp:label runat="server" id="msg" />
        &nbsp;&nbsp;&nbsp;&nbsp;
		<asp:Button ID="btn_refresh" runat="server" cssclass="input" Text="Refresh" OnClick="btn_refresh_Click" />

		<asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
		<ContentTemplate>
        <asp:GridView ID="GridView1" 
					  runat="server"
					  AutoGenerateColumns="False" 
					  DataKeyNames="ID"
					  DataSourceID="SqlDataSource1" 
					  ShowFooter="true" 
					  GridLines="None"
					  AllowPaging="True" 
					  AllowSorting="True" 
					  CssClass="mGrid"
					  PageSize="10"
					  emptydatatext="No reviews available."
					  PagerStyle-CssClass="pgr"
					  AlternatingRowStyle-CssClass="alt"
					  OnRowCommand="GridView1_RowCommand"
					  OnRowDatabound="GridView1_RowDataBound">
            <Columns>
                <asp:CommandField ShowEditButton="False"/>
				<asp:TemplateField >
					<ItemTemplate>
						<asp:LinkButton ID="App" CommandName="App" runat="server" CommandArgument='<%# Bind("Id")%>' Text="Approve"></asp:LinkButton>
						<asp:LinkButton ID="DApp" CommandName="DApp" runat="server" CommandArgument='<%# Bind("Id")%>' Text="Disapprove"></asp:LinkButton>
					</ItemTemplate>
				 </asp:TemplateField>

				 <asp:TemplateField HeaderText="Reviewer" SortExpression="FullName" itemstyle-wrap="true">
                    <ItemTemplate>
                        <asp:Label ID="Label7" runat="server" Text='<%# Bind("FullName") %>'></asp:Label>
                    </ItemTemplate>               
                </asp:TemplateField>

				 <asp:TemplateField HeaderText="Location" SortExpression="LocaName" itemstyle-wrap="true">
                    <ItemTemplate>
                        <asp:Label ID="Label8" runat="server" Text='<%# Bind("LocaName") %>'></asp:Label>
                    </ItemTemplate>
                 </asp:TemplateField>

				 <asp:TemplateField HeaderText="Rating" SortExpression="Rating" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Label ID="Label9" runat="server" Text='<%# Bind("Rating") %>'></asp:Label>
                    </ItemTemplate>               
                </asp:TemplateField>

				 <asp:TemplateField HeaderText="Review" SortExpression="Review" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Label ID="Label11" runat="server" Text='<%# Bind("Review") %>'></asp:Label>
                    </ItemTemplate>                
                </asp:TemplateField>

				<asp:TemplateField HeaderText="Authorized?" SortExpression="Authorized" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Label ID="Label12" runat="server" Text='<%# Bind("Authorized") %>'></asp:Label>
                    </ItemTemplate>                
                </asp:TemplateField>

				<asp:TemplateField HeaderText="Reviewed?" SortExpression="Reviewed" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Label ID="Label13" runat="server" Text='<%# Bind("Reviewed") %>'></asp:Label>
                    </ItemTemplate>                
                </asp:TemplateField>

				<asp:TemplateField HeaderText="Date Reviewed" SortExpression="ReviewDate" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Label ID="Label14" runat="server" Text='<%# Bind("ReviewDate") %>'></asp:Label>
                    </ItemTemplate>            
                </asp:TemplateField>               
            </Columns>
        </asp:GridView>
		<asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ProviderName="System.Data.SqlClient" 
			SelectCommand="p_gv_GetReviews @RestID">
			<SelectParameters>
				<asp:sessionparameter name="RestID" sessionfield="RestID" /> 
			</SelectParameters>
        </asp:SqlDataSource>
		</ContentTemplate>
		<Triggers>
			<asp:AsyncPostBackTrigger ControlID="btn_refresh" EventName="Click"></asp:AsyncPostBackTrigger>
		</Triggers>
		</asp:UpdatePanel>
    </div>
    </form>
</body>
</html>