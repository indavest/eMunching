<%@ Page Language="VB" debug="true" EnableSessionState="True"%>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ import Namespace="System.Collections"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<script runat="server">
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
    Dim appDisplaySettings As Hashtable = Nothing
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        dsStats.ConnectionString = connectionObject("connectionStringApp")
        RName.Text = Session("RestName")
        appDisplaySettings = Helper.getAppDisplaySettings(Session("RestID"))
    End Sub
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us">
<head id="Head1" runat="server">
<title>Admin Control Panel</title>
<script type="text/javascript" src="/js/carousel/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/js/carousel/jquery.jcarousel.min.js"></script>
<script type="text/javascript" src="/js/ShowHide.js"></script>
<link rel="stylesheet" type="text/css" href="/themes/skin2.css" />
<link rel="stylesheet" type="text/css" href="/themes/skin1.css" />
<link rel="stylesheet" type="text/css" href="/themes/stickyfooter.css" />
<script type="text/javascript">
    jQuery(document).ready(function () {
        jQuery('#mycarousel').jcarousel();
    });

    function showonlyone(thechosenone) {
        $('div[name|="newboxes"]').each(function (index) {
            if ($(this).attr("id") == thechosenone) {
                $(this).show(200);
                if ($(this).children('iframe')) {
                    $(this).children('iframe').attr("src", $(this).children('iframe').attr("src"));
                }
            }
            else {
                $(this).hide(600);
            }
        });
    } 
</script>
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

		#umlist{position:absolute;left:20px;top:100px;}
		#umlist li{margin:0;padding:0;list-style:none;}
		#umlist li, #umlist a{height:36px;display:block;}

		#um{left:0px;width:35px;}
		#um{background:url(/images/navigation/user_mgmt.png) 36px 0px;}
		#um a:hover{background: url(/images/navigation/user_mgmt.png) 0px 0px;}
</style>
<!--[if !IE 7]>
	<style type="text/css">
		#wrap {display:table;height:100%}
	</style>
<![endif]-->
</head>
<body>
	<ul id="umlist">
		<li id="um"><a href="UserMgmt.aspx"></a></li>
	</ul>
<div id="wrap">

	<div id="main">
    
<form id="Form1" runat="server">
<ajaxToolkit:ToolkitScriptManager runat="Server" EnableScriptGlobalization="true" EnableScriptLocalization="true" ID="ScriptManager1"/>
<DIV ID="block_top">
	<DIV CLASS="block_top_head">
		<table cellspacing="0" cellpadding="0" border="0" width="99%">
			<tr>
				<td align="left" width="320"><IMG SRC="../../../images/emunching_logo_AP_mod_sm.png" WIDTH="300" HEIGHT="63" BORDER="0" ALT=""></td>
				<td align="left"><a class="navlinkunselected" href="/" >Admin Control Panel for <asp:label runat="server" id="RName" /></a></td>
				<td align="right"><asp:LoginStatus ID="LoginStatus1" cssclass="Logout" LogoutAction="Redirect" LogoutPageUrl="/" runat="server" /></td>
			</tr>
		</table>
	</div>
</DIV>
<div id="block_top_under">
	<DIV CLASS="block_top_under_head">Welcome Back, <font color="#16a7e7"><asp:LoginName ID="LoginName1" runat="server" /></font>!</div>
</div>
<br><br>
<center>
<div id="wrap">
  <IMG SRC="/images/navigation/header-bg.png"  class="jcarousel-skin-tango" WIDTH="1000" HEIGHT="52" BORDER="0" ALT="">
  <ul id="mycarousel" class="jcarousel-skin-tango">
    <li id="a"><a href="javascript:showonlyone('newboxes1');"><img src="~/images/navigation/home_off.png" width="117" height="117" alt="" /></a></li>
	<li id="b"><a href="javascript:showonlyone('newboxes2');"><img src="~/images/navigation/menu_off.png" width="117" height="117" alt="" /></a></li>
	<li id="c"><a href="javascript:showonlyone('newboxes3');"><img src="~/images/navigation/orders_off.png" width="117" height="117" alt="" /></a></li>
	<li id="d"><a href="javascript:showonlyone('newboxes4');"><img src="~/images/navigation/reservation_off.png" width="117" height="117" alt="" /></a></li>
	<li id="e"><a href="javascript:showonlyone('newboxes5');"><img src="~/images/navigation/about_off.png" width="117" height="117" alt="" /></a></li>
	<li id="f"><a href="javascript:showonlyone('newboxes6');"><img src="~/images/navigation/settings_off.png" width="117" height="117" alt="" /></a></li>
	<li id="g"><a href="javascript:showonlyone('newboxes7');"><img src="~/images/navigation/uploads_off.png" width="117" height="117" alt="" /></a></li>
	<li id="h"><a href="javascript:showonlyone('newboxes8');"><img src="~/images/navigation/messages_off.png" width="117" height="117" alt="" /></a></li>
	<li id="i"><a href="javascript:showonlyone('newboxes9');"><img src="~/images/navigation/reports_off.png" width="117" height="117" alt="" /></a></li>
	<li id="j"><a href="javascript:showonlyone('newboxes10');"><img src="~/images/navigation/events_off.png" width="117" height="117" alt="" /></a></li>
	<li id="k"><a href="javascript:showonlyone('newboxes11');"><img src="~/images/navigation/deals_off.png" width="117" height="117" alt="" /></a></li>
	<li id="l"><a href="javascript:showonlyone('newboxes12');"><img src="~/images/navigation/reviews_off.png" width="117" height="117" alt="" /></a></li>
	<li id="m"><a href="javascript:showonlyone('newboxes13');"><img src="~/images/navigation/videos_off.png" width="117" height="117" alt="" /></a></li>
    <li id="n"><a href="javascript:showonlyone('newboxes14');"><img src="~/images/navigation/support_off.png" width="117" height="117" alt="" /></a></li>
  </ul>
  <table style="border:1px solid black;width:1000px;">
   <tr>
      <td>
         <div name="newboxes" id="newboxes1" style="border: 1px solid black; background-color: #CCCCCC; display: block;padding: 5px;">
			<center>
			<asp:Repeater id=Repeater1 runat="server" DataSourceID="dsStats">

				<HeaderTemplate>

					<table cellspacing="5" cellpadding="10" border="0" align="center">
					  
				</HeaderTemplate>

				<ItemTemplate>

					<tr>
					<th colspan="2">Orders</th>
					<th>&nbsp;</th>
					<th colspan="2">Reservations</th>
				</tr>
				<tr>
					<td>Total Orders Today:</td>
					<td><%# DataBinder.Eval(Container.DataItem, "Total Orders Today") %></td>
					<td>&nbsp;</td>
					<td>Total Reservations Today:</td>
					<td><%# DataBinder.Eval(Container.DataItem, "Total Reservations Today") %></td>
				</tr>
				<tr>
					<td>Total Current Orders In-Process (Today):</td>
					<td><%# DataBinder.Eval(Container.DataItem, "Total Orders In-Process Today") %></td>
					<td>&nbsp;</td>
					<td>Total Reservations Pending (Today):</td>
					<td><%# DataBinder.Eval(Container.DataItem, "Total Reservations Pending Today") %></td>
				</tr>
				<tr>
					<td>Total Orders This Week:</td>
					<td><%# DataBinder.Eval(Container.DataItem, "Total Orders This Week") %></td>
					<td>&nbsp;</td>
					<td>Total Reservations This Week:</td>
					<td><%# DataBinder.Eval(Container.DataItem, "Total Reservations This Week") %></td>
				</tr>
				<tr>
					<td colspan="5">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="5">&nbsp;</td>
				</tr>
				<tr>
					<th colspan="2">App Users</th>
					<th>&nbsp;</th>
					<th colspan="2">&nbsp;</th>
				</tr>
				<tr>
					<td>Total New Users Today:</td>
					<td><%# DataBinder.Eval(Container.DataItem, "Total Orders This Week") %></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>Total Active Users Today:</td>
					<td><%# DataBinder.Eval(Container.DataItem, "Total New Users Today") %></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>Total New Users This Week:</td>
					<td><%# DataBinder.Eval(Container.DataItem, "Total Active Users Today") %></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>Total Active Users This Week:</td>
					<td><%# DataBinder.Eval(Container.DataItem, "Total Active Users This Week") %></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>Total Users:</td>
					<td><%# DataBinder.Eval(Container.DataItem, "Total Users") %></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>

				</ItemTemplate>

				<FooterTemplate>

					</table>

				</FooterTemplate>

			</asp:Repeater>
			</center>
			<asp:SqlDataSource ID="dsStats" 
							   runat="server" 
							   ProviderName="System.Data.SqlClient" 
							   SelectCommand="p_gv_GetStats @RestID"
							   >
				<SelectParameters>
					<asp:sessionparameter name="RestID" sessionfield="RestID" /> 
				</SelectParameters>
			</asp:SqlDataSource>
		 </div>
		 <div name="newboxes" id="newboxes2" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
		 <h1>Menus</h1>
			<iframe frameborder="0" src="menus-landing.aspx" width="990px" height="700px"></iframe>
		 </div>
		 <div name="newboxes" id="newboxes3" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Orders</h1>
			<iframe frameborder="0" src="Order.aspx" width="990px" height="700px"></iframe>
		 </div>
         <div name="newboxes" id="newboxes4" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Reservations</h1>
			<iframe frameborder="0" src="resv.aspx" width="990px" height="700px"></iframe>
		 </div>
		 <div name="newboxes" id="newboxes5" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>About</h1>
			<iframe frameborder="0" src="about.aspx" width="990px" height="700px"></iframe>
		 </div>
         <div name="newboxes" id="newboxes6" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Console Settings/Configure Custom App</h1>
			<iframe frameborder="0" name="ThemeiFrame" src="Settings.aspx?Atab=0" width="890px" height="1050px"></iframe>
		 </div>
		 <div name="newboxes" id="newboxes7" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Uploads</h1>
			<iframe frameborder="0" src="Uploads.aspx" width="990px" height="700"></iframe>
		 </div>
         <div name="newboxes" id="newboxes8" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Email Templates</h1>
			<iframe frameborder="0" src="msg2.aspx" width="990px" height="700px"></iframe>
		 </div>
         <div name="newboxes" id="newboxes9" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Reports</h1>
		 </div>
		 <div name="newboxes" id="newboxes10" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Events</h1>
            <% If appDisplaySettings("Event") = 2 Then%>
			<iframe frameborder="0" src="EventsExtended.aspx" width="990px" height="700px"></iframe>
            <% Else%>
            <iframe frameborder="0" src="events.aspx" width="990px" height="700px"></iframe>
            <% End If %>
		 </div>
         <div name="newboxes" id="newboxes11" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Deals</h1>
            <% If appDisplaySettings("Event") = 2 Then%>
			<iframe frameborder="0" src="DealsExtended.aspx" width="990px" height="700px"></iframe>
            <% Else%>
            <iframe frameborder="0" src="deals.aspx" width="990px" height="700px"></iframe>
            <% End If %>
		 </div>
		 <div name="newboxes" id="newboxes12" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Reviews</h1>
			<iframe frameborder="0" src="reviews.aspx" width="990px" height="700px"></iframe>
		 </div>
         <div name="newboxes" id="newboxes13" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Videos</h1>
			<iframe frameborder="0" src="videos.aspx" width="990px" height="700px"></iframe>
		 </div>
         <div name="newboxes" id="newboxes14" style="border: 1px solid black; background-color: #CCCCCC; display: none;padding: 5px;">
			<h1>Support</h1>
			<iframe frameborder="0" src="support.aspx" width="990px" height="700px"></iframe>
		 </div>
      </td>
   </tr>
  </table> 

</div>
</div>

</div>
<div id="footer" align="center">
	<b>Copyright Indavest&copy;2011. All Rights Reserved.</b>
</div>
</center>
</form>
</body>
</html>




	