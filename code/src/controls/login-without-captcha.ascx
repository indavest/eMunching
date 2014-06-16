<%@ Control Language="C#" AutoEventWireup="true" CodeFile="login-without-captcha.ascx.cs" Inherits="controls_login_without_captcha" %>
<%-- LOGIN USER CONTROL WITHOUT CAPTCHA --%>
<div class="liWrap">
    <a name="login" id="login" style="display: block; height: 0px; width: 0px; border: 0px;"></a>
    <div class="liTitle">
        LOGIN</div>
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True" ValidationGroup="Login1" EnableClientScript="False" />
    <%-- success label --%>
    <div class="LiMessage">
        <asp:HyperLink ID="lblFailureText" runat="server" Width="240px" Visible="false" EnableViewState="false"></asp:HyperLink>
    </div>
    <div class="clearBoth"></div>
    <asp:Literal ID="Msg" runat="server" Visible="false"></asp:Literal>
    <asp:LoginView ID="loginBox" runat="server">
        <LoggedInTemplate>
        </LoggedInTemplate>
        <AnonymousTemplate>
			    <asp:Login ID="Login1" runat="server" OnAuthenticate="Login1_Authenticate" OnLoginError="Login1_LoginError" VisibleWhenLoggedIn="False" OnLoggingIn="Login1_LoggingIn">
				<LayoutTemplate>
				    <asp:Panel ID="pnlLogin" runat="server" DefaultButton="LoginButton">
					<DIV class="main">
					<table cellpadding="0" cellspacing="0" border="0" width="100%">
						<tr>
							<td>
								<p>
									<asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">Username:*</asp:Label>
									<asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" ErrorMessage="User Name is required." ToolTip="User Name is required." ValidationGroup="Login1" Display="Dynamic" EnableClientScript="False">*</asp:RequiredFieldValidator>
									<asp:TextBox ID="UserName" runat="server" TabIndex="1" ToolTip="enter your user name" MaxLength="50"></asp:TextBox>
									<br>
									<asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">Password:*</asp:Label>
									<asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="Login1" Display="Dynamic" EnableClientScript="False">*</asp:RequiredFieldValidator>
									<asp:TextBox ID="Password" runat="server" TabIndex="2" TextMode="Password" ToolTip="enter your password" MaxLength="50"></asp:TextBox>
									
									<hr>
									<asp:Button ID="LoginButton" runat="server" CommandName="Login" TabIndex="4" Text="Log In" ValidationGroup="Login1" />
									<br /><br />
									<asp:CheckBox ID="RememberMe" runat="server" TabIndex="5" Text="Remember me next time." />
									<br /><br />
									<asp:HyperLink ID="lnkLostPassword" runat="server" NavigateUrl="~/recover-password.aspx">Lost password?</asp:HyperLink>
								</p>
							</td>
							<td>
								<img class="chef" src="images/right-chef/chef_03.png">
								<img class="chef" src="images/right-chef/chef_05.png"> 
								<img class="chef" src="images/right-chef/chef_07.png"> 
								<img class="chef" src="images/right-chef/chef_09.png"> 
								<img class="chef" src="images/right-chef/chef_11.png"> 
								<img class="chef" src="images/right-chef/chef_12.png"> 
								<img class="chef" src="images/right-chef/chef_14.png"> 
								<img class="chef" src="images/right-chef/chef_16.png"> 
								<img class="chef" src="images/right-chef/chef_18.png"> 
								<img class="chef" src="images/right-chef/chef_20.png"> 
								<img class="chef" src="images/right-chef/chef_22.png"> 
								<img class="chef" src="images/right-chef/chef_24.png"> 
								<img class="chef" src="images/right-chef/chef_26.png"> 
								<img class="chef" src="images/right-chef/chef_28.png"> 
								<img class="chef" src="images/right-chef/chef_30.png"> 
								<img class="chef" src="images/right-chef/chef_32.png"> 
								<img class="chef" src="images/right-chef/chef_33.png"> 
								<img class="chef" src="images/right-chef/chef_36.png"> 
								<img class="chef" src="images/right-chef/chef_38.png"> 
								<img class="chef" src="images/right-chef/chef_40.png">
							</td>
						</tr>
					</table>
					</div>
				    </asp:Panel>
				</LayoutTemplate>
			    </asp:Login>

        </AnonymousTemplate>
    </asp:LoginView>
    <asp:LoginView ID="userStatus" runat="server">
        <LoggedInTemplate>
            <div class="logoutIcon">
            </div>
            <div style="font-size: 20px;">
                Welcome!
                <asp:LoginName ID="LoginName1" runat="server" />
            </div>
            You are currently logged in.
            <br />
            <br />
            <asp:LoginStatus ID="LoginStatus1" runat="server" />
        </LoggedInTemplate>
    </asp:LoginView>
</div>
