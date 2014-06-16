<%@ Page Language="VB" debug="true"%>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>
<script runat="server">
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
	Dim DBConn As New SqlConnection(connectionObject("connectionStringApp"))

	Sub Page_Load(sender As Object, e As EventArgs)
        AvailThemes.ConnectionString = connectionObject("connectionStringApp")
		If Not Page.IsPostBack then
			Dim DBAdap As New SqlDataAdapter
			Dim DS As New DataSet
			Dim DBCmd As New SqlCommand
			Dim DR As SqlDataReader

			DBConn.Open()
			DBCmd = New SqlCommand("p_gv_GetTheme @Theme", DBConn)
			DBCmd.Parameters.Add("@Theme", SqlDbType.Int).Value = 0
			DR = DBCmd.ExecuteReader()
			ThemeImages.DataSource = DR
			ThemeImages.DataBind()
			DR.Close()
			DR = Nothing
			DBConn.Close()
		End If
	End Sub

	Protected Sub ddlThemes_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
		
		Dim DBAdap As New SqlDataAdapter
		Dim DS As New DataSet
		Dim DBCmd As New SqlCommand
		Dim DR As SqlDataReader

		DBConn.Open()
		DBCmd = New SqlCommand("p_gv_GetTheme @Theme", DBConn)
		DBCmd.Parameters.Add("@Theme", SqlDbType.Int).Value = ddlThemes.SelectedItem.Value
		DR = DBCmd.ExecuteReader()
		ThemeImages.DataSource = DR
		ThemeImages.DataBind()
		DR.Close()
		DR = Nothing
		DBConn.Close()

	End Sub

	Protected Sub SubmitButton_Click(sender As Object, e As EventArgs)
		
		Dim objCmd As SQLCommand
		Dim sqlCmd As String
				
		sqlCmd = "EXECUTE p_gv_InsertAppTheme '" & Session("RestID") & "','" & _
												   ddlThemes.selectedItem.Value & "'"

		objCmd = New SQLCommand(sqlCmd, DBConn)
		DBConn.Open()
		objCmd.ExecuteNonQuery()
		DBConn.Close()

		msg.Text = "Theme successfully selected and submitted to Indavest."

	End Sub
</script>
<head>
	<link rel="stylesheet" media="all" type="text/css" href="/themes/slide.css" />
	<script src="/js/jquery-1.4.2.min.js" type="text/javascript"></script>
	<script src="/js/slide.js" type="text/javascript"></script>
</head>
<body>
	<form runat="server">
		<div id="content">
			<asp:label runat="server" id="msg" name="msg" Text="" />
			<div id="slideshow">
				<div id="imageBack"></div>
					<h1 class="title">
					<asp:DropDownList ID="ddlThemes"
									  cssclass="input"
									  Runat="server"
									  DataSourceID="AvailThemes" 
									  DataTextField="Name" 
									  DataValueField="ThemeID"
									  AutoPostBack="true" 
									  OnSelectedIndexChanged="ddlThemes_SelectedIndexChanged">
					</asp:DropDownList>
					<asp:SqlDataSource ID="AvailThemes" 
									   runat="server" 
									   SelectCommand="p_gv_SelectThemes">
					</asp:SqlDataSource>
					<asp:button runat="server" id="RestSelect" Text="Select this Theme" cssclass="input" onclick="SubmitButton_Click" />
					</h1>
				<div id="buttons">
					<p></p>
				</div>
				<div id="previous"></div>
				<div id="next"></div>
					<p id="number"><span class="picNo"></span>&nbsp;of&nbsp;<span class="picTotal"></span></p>
					<asp:Repeater id="ThemeImages" runat="server">
						<ItemTemplate>
							<div class="imageHolder">
								<img src="blank.gif" alt="<%#Container.DataItem("ImagePath")%>" title="Theme1" />
							</div>

							<div class="imageText">
								<div>
									<h1><%#Container.DataItem("ImageTitle")%></h1>
									<p><%#Container.DataItem("ImageDesc")%></p>
									<b></b>
									<p><i><%#Container.DataItem("LegalNotice")%></i></p>
								</div>
							</div>
						</ItemTemplate>
					</asp:Repeater>
		</div>
	</form>