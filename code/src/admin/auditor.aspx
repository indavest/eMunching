<%@ Page Title="Auditor" Language="C#" MasterPageFile="~/admin/themes/default/default.master" AutoEventWireup="true" CodeFile="auditor.aspx.cs" Inherits="admin_auditor" %>

<%@ Register Src="controls/Auditor.ascx" TagName="auditor" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
	<script type="text/javascript" src='<%=Page.ResolveUrl("~/js/jquery-1.7.1.min.js") %>'></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <uc1:auditor ID="re1" runat="server" />
</asp:Content>
