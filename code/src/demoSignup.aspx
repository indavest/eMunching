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
	
			If chk1.Checked = True
				Try
					Dim mail As New MailMessage()
					mail.To = "contact@emunching.com"
					mail.From = "Emunching.com <no-reply@emunching.com>"
					mail.Subject = "Demo Request"
					mail.BodyFormat = MailFormat.Html
					mail.Body = "Hi,<br /><br />There is a new Demo request from <strong>"+name.Text+"</strong>. Please find all the details below:<br />" & _
								"Name: " + name.Text + "<br>" & _
								"Email: " + email.Text + "<br>" & _
								"Phone Number: " + number.Text + "<br>" & _
								"Restaurant Name: " + rest.Text + "<br>" & _
								"Website: " + website.Text + "<br>"
					SmtpMail.SmtpServer = "localhost"
					SmtpMail.Send(mail)
					Response.Redirect("http://www.emunching.com/eMunchingDemo.html")
					
				Catch ex as exception
					msg.Text = "Oops! There has been an error: " & ex.Message & ". Our web team is aware of the error and is looking into it."
				End Try
			Else
				Msg.Text = "You MUST agree to the terms before signing up for the beta!"
			End If
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
window.location.href = "index.html";
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
			 <label for="name">Your Name</label>
			 <asp:textbox runat="server" id="name" />
			 <asp:RequiredFieldValidator ControlToValidate="name" 
										 Text="Please Enter Your Name." 
										 runat="server" />
		   </div>
		   <div>
			 <label for="number">Your No.</label>
			 <asp:textbox runat="server" id="number" />
			 <asp:RequiredFieldValidator ControlToValidate="number" 
										 Text="Please Enter Your number." 
										 runat="server" />
		   </div>
		   <div>
			 <label for="email">Your Email</label>
			 <asp:textbox runat="server" id="email" />
			 <asp:RegularExpressionValidator ControlToValidate="email" 
											 ValidationExpression="^[\w-]+(\.[\w-]+)*@([a-z0-9-]+(\.[a-z0-9-]+)*?\.[a-z]{2,6}|(\d{1,3}\.){3}\d{1,3})(:\d{4})?$" 
											 EnableClientScript="false" 
											 ErrorMessage="The e-mail address you entered is not valid." 
											 runat="server" />
		   </div>
		   <div>
			 <label for="rest">Your Rest.</label>
			 <asp:textbox runat="server" id="rest" />
			 <asp:RequiredFieldValidator ControlToValidate="rest" 
										 Text="Please Enter Your Restaurant name." 
										 runat="server" />
		   </div>
		   <div>
			 <label for="userweb">Website</label>
			 <asp:textbox runat="server" id="website" />
		   </div>
		   <div id="term" style="padding:0 0 10px 10px;">
				<div class="checkBox" id="chk"></div>
				<label for="chk">I have read and agreed to the <a href="#" id="terms">Terms and Conditions</a></label>
		   </div>
		   <asp:checkbox runat="server" id="chk1" cssclass="checkBoxDuplicate" />
		   <asp:Button	id="btnSubmit" Text="Sign Up" Runat="server" cssclass="btnActive" onclick="SubmitButton_Click" />
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