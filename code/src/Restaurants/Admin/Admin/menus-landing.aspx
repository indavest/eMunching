<%@ Page Language="VB" debug="true"%>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>
<script runat="server">
    Dim helpers As New Helper
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
        Dim con As New SqlConnection(connectionObject("connectionStringApp"))
        con.Open()
		Dim cmd As New SqlCommand("p_Site_RestaurantCountryLookup @RestID", con)
		cmd.Parameters.AddWithValue("@RestID", Session("RestID"))
		Dim strCountry As String = Convert.ToString(cmd.ExecuteScalar())
		con.Close()
		con.Dispose()

		If strCountry = 1 Then
		    Response.Redirect("menusUS.aspx", False)
		Else
			Response.Redirect("menusNonUS.aspx", False)
		End If
	 End Sub
</script>