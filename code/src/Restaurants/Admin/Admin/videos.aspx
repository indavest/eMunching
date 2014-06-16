<%@ Page Language="C#" AutoEventWireup="true" CodeFile="videos.aspx.cs" Inherits="Restaurants_Admin_Admin_videos" %>

<%Response.Redirect("http://" + HttpContext.Current.Request.Url.Host + @"/eMunchingVideos/?RestId=" + Session["RestId"]);%>

