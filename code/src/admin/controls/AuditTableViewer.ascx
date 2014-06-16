<%@ Control Language="VB" AutoEventWireup="true" %>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>
<script runat="server">
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        TableListDS.ConnectionString = connectionObject("connectionStringApp")
        SqlDataSource1.ConnectionString = connectionObject("connectionStringApp")
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
    <font color="red"><b>
    Select a Table to review.
    </b></font>
</div>
<div width="75%">
   <asp:label runat="server" id="msg" /><br>
   <asp:DropDownList ID="DropDownList1" 
		     runat="server" 
		     AutoPostBack="True" 
		     DataSourceID="TableListDS"
		     DataTextField="TableName" 
		     DataValueField="TableName">
   </asp:DropDownList>
   <asp:SqlDataSource ID="TableListDS" 
		      runat="server" 
		      ProviderName="System.Data.SqlClient" 
		      SelectCommand="p_gv_SelectAuditTableList">
   </asp:SqlDataSource>
   <br>
   <asp:GridView ID="GridView1" 
		  runat="server"
		  AutoGenerateColumns="True" 
		  DataKeyNames="ID"
		  DataSourceID="SqlDataSource1" 
		  ShowFooter="false" 
		  GridLines="None"
		  AllowPaging="True" 
		  AllowSorting="True" 
		  CssClass="mGrid"
		  PageSize="15"
		  emptydatatext="There aren't any existing audit records."
		  PagerStyle-CssClass="pgr"
		  AlternatingRowStyle-CssClass="alt"
		  EnableModelValidation="True">
   </asp:GridView>
   <asp:SqlDataSource ID="SqlDataSource1" 
		      runat="server" 
		      ProviderName="System.Data.SqlClient" 
		      SelectCommand="p_Audit_SelectTableLog_All @TableName">
   </asp:SqlDataSource>
   <SelectParameters>
        <asp:ControlParameter ControlID="DropDownList1" Name="TableName" PropertyName="SelectedValue" />
    </SelectParameters>
</div>