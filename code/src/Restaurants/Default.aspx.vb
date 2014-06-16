Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.Security
Imports System.Security.Principal
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports Utilities

Public Partial Class members_Default
	Inherits System.Web.UI.Page
	Protected Sub Page_Load(sender As Object, e As EventArgs)
		If Not String.IsNullOrEmpty(User.Identity.Name) Then
			Session("UserLogin") = User.Identity.Name
			Session("UserID") = Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey.ToString()
		End If

        Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
        Dim objConn As New SqlConnection(connectionObject("connectionStringApp"))
		Dim objCmd = New SqlCommand("p_SelectUserPath '" & User.Identity.Name & "'", objConn)
				objConn.Open()
				Dim objReader As SqlDataReader = objCmd.ExecuteReader()

				While objReader.Read()
					Session("RestId") = objReader("Restaurant").ToString()
					Session("RestName") = objReader("name").ToString()
            Response.Redirect(StringConstants.RESTAURANT_ADMIN_PATH)
				End While
				objConn.Close()

	End Sub
End Class