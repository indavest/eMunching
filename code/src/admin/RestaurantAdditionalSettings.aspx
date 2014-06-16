<%@ Page Language="C#" Title="Restaurant Additional Settings" AutoEventWireup="true" MasterPageFile="~/admin/themes/default/default.master" CodeFile="RestaurantAdditionalSettings.aspx.cs" Inherits="admin_RestaurantAdditionalSettings" %>

<%@ Register Src="controls/restaurantAdditonalSettings.ascx" TagName="restaurantadditionalsettings" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <uc1:restaurantadditionalsettings ID="re1" runat="server" />
</asp:Content>
