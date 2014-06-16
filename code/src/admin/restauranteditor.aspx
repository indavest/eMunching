<%@ Page Title="RestaurantEditor" Language="C#" MasterPageFile="~/admin/themes/default/default.master" AutoEventWireup="true" CodeFile="restauranteditor.aspx.cs" Inherits="admin_restauranteditor" %>

<%@ Register Src="controls/restauranteditor.ascx" TagName="restauranteditor" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <uc1:restauranteditor ID="re1" runat="server" />
</asp:Content>
