<%@ Page Language="VB" debug="true"%>
<%@ import Namespace="System.Data"%>
<%@ import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Configuration"%>
<%@ import Namespace="System.IO"%>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Web.Mail" %>
<%@ Import Namespace="System.Security.Principal" %>
<script runat="server">
	Sub SubmitButton_Click(s As Object, e As EventArgs)
		Try
			If username.Text <> "emunchingDemo" OR password.Text <> "emunchingDemo"
				msg.Text = "<div class='successMsg'><div class='successMsgTop'></div><div class='successMsgMid'><p>Your username and password didnot match. Please try again.</p><input type='button' value='Ok' name='go' class='btnOk' onclick='indexReturn()' /></div><div class='successMsgFoot'></div></div>"
			Else
				Response.Redirect("http://www.pieceable.com/view/bundle/bre/077a2/com.indavest.eMunching")
			End If
		Catch ex as exception
			msg.Text = "Oops! There has been an error: " & ex.Message & ". Our web team is aware of the error and is looking into it."
		End Try
			
	End Sub
</script>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Welcome to Emunching | Sign up</title>
<link rel="stylesheet" href="css/site.css" type="text/css" />
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
<script type="text/javascript" src="js/effectScript.js"></script>
<script type="text/javascript" src="js/slider.js"></script>
<script type="text/javascript">
function indexReturn() {
window.location.href = "demoLogin.aspx";
}

function returnPage() {
 window.location.href = "signup.php";
}
</script>
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-20092473-4']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
</head>
<body class="design">
<form runat="server">
<!--[if IE 9]> <div id="ie9"> <![endif]-->
<div id="container">
<header>
   <a href="index.html"><img src="images/logo.jpg" width="484" height="92" alt="Emunching" title="emunching" id="emunchingLogo"/></a>
   <!-- PopUps Starts -->
     <div id="popupAboutContainer">
         <img src="images/popup-close.png" width="22" height="20" id="closex" alt="close" />
         <div id="popupAboutContainerWrapper"></div>
     </div>
     <div id="popupPricingContainer">
         <img src="images/popup-close.png" width="22" height="20" id="closey" alt="close" />
         <div id="popupPricingContainerWrapper"></div>
     </div>
     <div id="popupTermsContainer">
         <img src="images/popup-close.png" width="22" height="20" id="close" alt="close" />
        <div id="popupTermsContainerWrapper"></div>
     </div>  
     <div id="backgroundPopup"></div>
   <!-- PopUps Ends -->
   <div id="signUpLoader">
	<p>Please enter your<br/> details and we will<br/> be<br/> in touch!</p>
    </div>
    <div id="signUpScreen">
     <div id="slideScreen">
       <div id="slideScreenWrapper">Your email will not be shared with anyone</div>
     </div>
	 <asp:label runat="server" id="msg" />
	 <div id="signupForm">
		   <div>
			 <label for="name">User Name</label>
			 <asp:textbox runat="server" id="username" />
			 <asp:RequiredFieldValidator ControlToValidate="username" 
										 Text="Please Enter User Name." 
										 runat="server" />
		   </div>
		   <div>
			 <label for="number">Password</label>
			 <asp:textbox runat="server" id="password" />
			 <asp:RequiredFieldValidator ControlToValidate="password" 
										 Text="Please Enter Password." 
										 runat="server" />
		   </div>
		   <div id="term" style="padding:0 0 10px 10px;">
				<label for="chk">Please request Demo login <a href="demoSignup.aspx">here</a></label>
		   </div>
		   <asp:Button	id="btnSubmit" Text="Sign In" Runat="server" cssclass="btnActive demoSubmit" onclick="SubmitButton_Click" />
	  </div>
   </div>
    <div id="ivlogo">
     <a href="http://www.indavest.com" target="_blank"><img src="images/logo-indavest.png" width="122" height="116" alt="Indavest" id="logo" /></a>
    </div>
    <div id="logoFix"></div>
    <nav id="menu">
      <ul>
        <li class="first"><a href="index.html">Home</a></li>
        <li><a href="tour.html">Tour</a></li>
        <li class="fix"><a href="#">About</a></li>
        <li><a href="#">Pricing</a></li>
        <li class="last"><a href="contact.html">Contact</a></li>
      </ul>
    </nav>
</header>
</div>
<div id="containerFooter">
<footer><p>&copy; 2011. Emunching.com</p></footer>
</div>
</form>
</body>
</html>