<%@ Control Language="C#" AutoEventWireup="true" CodeFile="restaurantAdditonalSettings.ascx.cs" Inherits="admin_controls_restaurantAdditonalSettings" %>
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
        #restAddSettingsWrapper{margin: 0 auto;}
        #restAddSettingsWrapper>h3{width:auto;}
	</style>
<div class="adminHelp">
    Mail Settings and Notification settings can be managed here
</div>
<div id="restAddSettingsContainer">
    <asp:Label runat="server" ID="msg" /><br />
    <div id="restAddSettingsWrapper">
        <asp:Label runat="server" ID="reataurantName" Font-Bold="True" 
            Font-Size="X-Large" />
        
            <div>
                <h3>Emails Enabled</h3>
                <asp:CheckBoxList ID="emailOptionList" runat="server"></asp:CheckBoxList>
            </div>
            <div>
                <h3>Notifications Enabled</h3>
                <asp:CheckBoxList ID="notificationOptionList" runat="server"></asp:CheckBoxList>
            </div>
            <div style="margin:10px 0">
                <h3>Upload Certificate</h3>
                <asp:Label ID="certificateLabel" runat="server"></asp:Label>
                <asp:FileUpLoad id="uploadCertificate" runat="server" />
            </div>
            <asp:Button Text="Save" ID="Save" Runat="server" cssclass="input" 
                onclick="Save_Click"/>
        
    </div>
</div>

