<%@ Page Title="AuditViewer" Language="C#" MasterPageFile="~/admin/themes/default/default.master" AutoEventWireup="true" CodeFile="auditviewer.aspx.cs" Inherits="admin_auditviewer" %>

<%@ Register Src="controls/AuditViewer.ascx" TagName="auditviewer" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <uc1:auditviewer ID="re1" runat="server" />
</asp:Content>
