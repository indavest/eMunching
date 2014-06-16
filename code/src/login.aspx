<%@ Page Title="eMunching" Language="C#" MasterPageFile="~/themes/default/default.master" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="login" EnableViewState="false" %>
<%@ Register Src="controls/login-without-captcha.ascx" TagName="LoginWithoutCaptcha" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<meta name="robots" content="NOINDEX, NOFOLLOW"/>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
  <uc1:LoginWithoutCaptcha ID="LoginWithoutCaptcha1" runat="server" />
</asp:Content>