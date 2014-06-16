<%@ Page Language="VB" debug="true"%>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Security.Principal" %>
<script runat="server">
    Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
	Sub Page_Load(sender As Object, e As EventArgs)

			Dim dirInfo2 As New DirectoryInfo(Server.MapPath("/Restaurants/TMG Cafe/ArtWork/AppIcons/"))
			Dim fileInfo2 As FileInfo() = dirInfo2.GetFiles("*.*", SearchOption.AllDirectories)
            AvailFonts.ConnectionString = connectionObject("connectionStringApp")
			AppArtDDL.DataSource = fileinfo2
			AppArtDDL.DataTextField = "Name"
			AppArtDDL.DataValueField = "Name"
			AppArtDDL.DataBind()

	End Sub

	Sub SaveAppConfig_Click(s As Object, e As EventArgs)
		
        Dim connectionObject As Hashtable = Helper.getDBNamesAndConnectionStrings()
        Dim objConn As New SqlConnection(connectionObject("connectionStringApp"))
			Dim objCmd As SQLCommand
			Dim sqlCmd As String

			'sqlCmd = "EXECUTE p_SaveAppConfig '" & Session("RestID") & "','" & _
			'									   Color1.Text & "','" & _
			'									   Font1.Text & "','" & _
			'									   FontSize1.Text & "','" & _
			'									   FontColor1.Text & "','" & _
			'									   FontStyle1.Text & "','" & _
			'									   AppArtDDL.selectedItem.Value & "'"
														  
			objCmd = New SQLCommand(sqlCmd, objConn)
			objConn.Open()
			objCmd.ExecuteNonQuery()
			objConn.Close()

			Response.Redirect("iPhoneTemplate.aspx")

	End Sub
</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
  <title></title>
  <script type="text/javascript" src="jquery.js"></script>
  <script type="text/javascript" src="jquery.wheelcolorpicker.min.js"></script>
  <script type="text/javascript">
		$(function() {
			$('.colorpicker').wheelColorPicker({dir: '/images/'});
		});
  </script>
  <script type="text/javascript">
	function changeStyle(){
		document.getElementById("PlaceHolder1").style.backgroundColor = document.getElementById("Color1").value;
		document.getElementById("PlaceHolder1").style.font = document.getElementById("FontStyle1").value + ' ' 
														   + document.getElementById("FontSize1").value + ' ' 
														   + document.getElementById("Font1").value;
		document.getElementById("PlaceHolder1").style.backgroundImage = 'url(/Restaurants/TMG%20Cafe/ArtWork/AppIcons/' + document.getElementById("AppArtDDL").value + ')';
		document.getElementById("PlaceHolder1").style.color = document.getElementById("FontColor1").value;
		document.getElementById("PlaceHolder2").style.backgroundColor = document.getElementById("Color1").value;
		document.getElementById("PlaceHolder2").style.font = document.getElementById("FontStyle1").value + ' ' 
														   + document.getElementById("FontSize1").value + ' ' 
														   + document.getElementById("Font1").value; 
		document.getElementById("PlaceHolder2").style.color = document.getElementById("FontColor1").value;
		document.getElementById("PlaceHolder3").style.backgroundColor = document.getElementById("Color1").value;
		document.getElementById("PlaceHolder3").style.font = document.getElementById("FontStyle1").value + ' ' 
														   + document.getElementById("FontSize1").value + ' ' 
														   + document.getElementById("Font1").value;
		document.getElementById("PlaceHolder3").style.color = document.getElementById("FontColor1").value;
	}

	function originalStyle(){
		document.getElementById("PlaceHolder1").style.backgroundColor = "white";
		document.getElementById("PlaceHolder1").style.font = "12px arial,serif";
		document.getElementById("PlaceHolder1").style.backgroundImage = '';
		document.getElementById("PlaceHolder2").style.backgroundColor = "white";
		document.getElementById("PlaceHolder2").style.font = "12px arial,serif";
		document.getElementById("PlaceHolder2").style.backgroundImage = '';
		document.getElementById("PlaceHolder3").style.backgroundColor = "white";
		document.getElementById("PlaceHolder3").style.font = "12px arial,serif";
		document.getElementById("PlaceHolder3").style.backgroundImage = '';
		
		document.getElementById("Font1").selectedIndex = 0;
		document.getElementById("FontColor1").selectedIndex = 0;
		document.getElementById("FontStyle1").selectedIndex = 0;
		document.getElementById("FontSize1").selectedIndex = 0;
		document.getElementById("Color1").selectedIndex = 0;
		document.getElementById("Image1").selectedIndex = 0;
	}
  </script>
 </head>
 <body bgcolor="#CCCCCC">
 <form runat="server">
 <table cellspacing="0" cellpadding="10" border="0">
	<tr>
		<td>
		  <img src="/images/iPhone-Template3.png" width="458" height="996" border="0" alt="">
		  <div id="PlaceHolder1" style="position:absolute;top:196px;left:54px;width:382px;height:80px;background-color:white;border: dashed 1px black;font:12px arial,serif;">Header/Logo - W 382.5px H 80px</div>
		  <div id="PlaceHolder2" style="position:absolute;top:276px;left:54px;width:382px;height:200px;background-color:white;border: dashed 1px black;font:12px arial,serif;">Content 1</div>
		  <div id="PlaceHolder3" style="position:absolute;top:476px;left:54px;width:382px;height:200px;background-color:white;border: dashed 1px black;font:12px arial,serif;">Content 2</div>
		  <div id="PlaceHolder4" style="position:absolute;top:676px;left:54px;width:382px;height:68px;background-color:white;border: dashed 1px black;font:12px arial,serif;">Taskbar</div>
		  <!--<br>ORIG: Y181,Z700,X419,Z(2)700
		  <br>MOD: T189,L45.5,W382.5,H548-->
		</td>
		<td>
		  <table cellspacing="0" cellpadding="0" border="0" style="border:1px solid black;">
			<tr>
				<th colspan="2" align="center">Header/Logo, Content 1, Content 2</th>
			</tr>
			<tr>
				<td>Background Color</td>
				<td>
					<input type="text" class="colorpicker" id="Color1" Size="5" />
				</td>
			</tr>
			<tr>
				<td>Font, Color, Size, Style</td>
				<td>
					<asp:DropDownList ID="Font1"
									  cssclass="input"
									  Runat="server"
									  DataSourceID="AvailFonts" 
									  DataTextField="FontName" 
									  DataValueField="FontName">
						<asp:ListItem Text="<Select a Font>" Value="Helvetica-Bold" />
					</asp:DropDownList>
					<asp:SqlDataSource ID="AvailFonts" 
									   runat="server" 
									   SelectCommand="p_SelectFonts">
					</asp:SqlDataSource>
					&nbsp;
					<asp:DropDownList ID="FontSize1"
									  cssclass="input"
									  Runat="server">
						<asp:ListItem Text="17px" Value="17px" />
						<asp:ListItem Text="20px" Value="20px" />
						<asp:ListItem Text="23px" Value="23px" />
					</asp:DropDownList>
					&nbsp;
					<input type="text" class="colorpicker" id="FontColor1" size="5"/>
					&nbsp;
					<select id="FontStyle1" size="1">
						<option value="" selected>None</option>
						<option value="bold">Bold</option>
						<option value="italic">Italic</option>
						<option value="bold italic">Bold, Italic</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>Existing App Logos</td>
				<td>
					<asp:DropDownList ID="AppArtDDL" runat="server" ></asp:DropDownList>
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		  </table>
		  <br><button type="button" id="btn" runat="server" onclick="changeStyle();">Change Style(s)</button>&nbsp;&nbsp;<button type="button" id="btn1" runat="server" onclick="originalStyle();">Reset</button>
		  
		 </td>
	</tr>
	<tr>
		 <td colspan="2" align="center">
			<asp:Button id="btnSaveAppConfig" runat="server" Text="Save Config and Submit for Publication" Font-Bold="True" cssclass="input" onClick="SaveAppConfig_Click"/>
		 </td>
	</tr>
</table>
</form>
 </body>
</html>