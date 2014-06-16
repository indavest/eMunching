<%@ Control Language="VB" AutoEventWireup="true" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.Collections.Generic" %>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ import Namespace="System.Linq" %>
<%@ import Namespace="System.Web" %>
<%@ import Namespace="System.Web.UI" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>
<Script runat="server">
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        dsStats.ConnectionString = connectionObject("connectionStringApp")
    End Sub
    
	Protected Sub CreateAuditTablesButton_Click(sender As Object, e As EventArgs)
		lblSummary.Text = "The following tables are now being audited.<br><ul>"
		
		For Each row As GridViewRow In gvAuditedTables.Rows
			Dim cb = TryCast(row.FindControl("chkSelected"), CheckBox)

			If cb.Checked Then
				Dim currentRowsFilePath = gvAuditedTables.DataKeys(row.RowIndex).Value.ToString()
				
				Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
Dim objConn As New SqlConnection(connectionObject("connectionStringApp"))
				Dim objCmd As SQLCommand
				Dim sqlCmd As String
				
				sqlCmd = "EXECUTE eMunching.dbo.p_Audit_CreateShadowTable '" & currentRowsFilePath & "'"
									
				objCmd = New SQLCommand(sqlCmd, objConn)
				objConn.Open()
				objCmd.ExecuteNonQuery()
				objConn.Close()

				gvAuditedTables.DataBind()

				lblSummary.Text += [String].Concat("<li>", currentRowsFilePath, "</li>")
			End If
		Next

		lblSummary.Text += "</ul>"
	End Sub

	Protected Sub RemoveAuditTablesButton_Click(sender As Object, e As EventArgs)
		lblSummary.Text = "The following tables are no longer being audited.<br><ul>"
		
		For Each row As GridViewRow In gvAuditedTables.Rows
			Dim cb = TryCast(row.FindControl("chkSelected"), CheckBox)

			If cb.Checked Then
				Dim currentRowsFilePath = gvAuditedTables.DataKeys(row.RowIndex).Value.ToString()
				
				Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
                Dim objConn As New SqlConnection(connectionObject("connectionStringApp"))
				Dim objCmd As SQLCommand
				Dim sqlCmd As String
				
				sqlCmd = "EXECUTE eMunching.dbo.p_Audit_DropTableTriggers '" & currentRowsFilePath & "';EXECUTE eMunching_Audit.dbo.p_Audit_DropShadowTable '" & currentRowsFilePath & "'"
									
				objCmd = New SQLCommand(sqlCmd, objConn)
				objConn.Open()
				objCmd.ExecuteNonQuery()
				objConn.Close()

				gvAuditedTables.DataBind()
				
				lblSummary.Text += [String].Concat("<li>", currentRowsFilePath, "</li>")
			End If
		Next

		lblSummary.Text += "</ul>"
	End Sub
</script>

	<script type="text/javascript">
		var allCheckBoxSelector = '#<%=gvAuditedTables.ClientID%> input[id*="chkAll"]:checkbox';
		var checkBoxSelector = '#<%=gvAuditedTables.ClientID%> input[id*="chkSelected"]:checkbox';

		function ToggleCheckUncheckAllOptionAsNeeded() {
		    var totalCheckboxes = $(checkBoxSelector),
			checkedCheckboxes = totalCheckboxes.filter(":checked"),
			noCheckboxesAreChecked = (checkedCheckboxes.length === 0),
			allCheckboxesAreChecked = (totalCheckboxes.length === checkedCheckboxes.length);

		    $(allCheckBoxSelector).attr('checked', allCheckboxesAreChecked);
		}

		$(document).ready(function () {
		    $(allCheckBoxSelector).live('click', function () {
			$(checkBoxSelector).attr('checked', $(this).is(':checked'));

			ToggleCheckUncheckAllOptionAsNeeded();
		    });

		    $(checkBoxSelector).live('click', ToggleCheckUncheckAllOptionAsNeeded);
		    
		    ToggleCheckUncheckAllOptionAsNeeded();
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

    <p>
        <asp:Label ID="lblSummary" runat="server" EnableViewState="False" Font-Bold="False" Font-Italic="False" ForeColor="Red"></asp:Label>&nbsp;</p>
    <p>
        <asp:GridView ID="gvAuditedTables" 
					  runat="server" 
					  CellPadding="4"
					  ForeColor="#333333" 
					  GridLines="None" 
					  AutoGenerateColumns="False" 
					  DataSourceID="dsStats"
					  DataKeyNames="TableName"
					  ShowFooter="false" 
					  AllowPaging="True" 
					  AllowSorting="True" 
					  CssClass="mGrid"
					  PageSize="50"
					  emptydatatext="There aren't any existing tables in the audit list."
					  PagerStyle-CssClass="pgr"
					  AlternatingRowStyle-CssClass="alt"
					  >
            <Columns>
                <asp:TemplateField>
                    <HeaderTemplate>
                        Select All <asp:CheckBox runat="server" ID="chkAll" />
                    </HeaderTemplate>
                    <ItemTemplate>
                        <asp:CheckBox runat="server" ID="chkSelected" checked='<%# Bind("Audited")%>'/>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="TableName" HeaderText="Table Name" />
                <asp:BoundField DataField="TableDesc" HeaderText="Description" />
            </Columns>
        </asp:GridView>
		<asp:SqlDataSource ID="dsStats" 
						   runat="server" 
						   ProviderName="System.Data.SqlClient" 
						   SelectCommand="p_gv_SelectAuditedTables"
						   >
		</asp:SqlDataSource>
    </p>
    <p>
        <asp:Button runat="server" ID="CreateAuditTablesButton" Text="Create Audit Trail for Selected Tables" cssclass="input" onclick="CreateAuditTablesButton_Click" />
		<asp:Button runat="server" ID="RemoveAuditTablesButton" Text="Remove Audit Trail for Selected Tables" cssclass="input" onclick="RemoveAuditTablesButton_Click" />
    </p>  
