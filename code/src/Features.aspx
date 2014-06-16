<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Features.aspx.cs" Inherits="Features" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8"/>    <meta name="Author" content="Prasad CH, prasad@indavest.com"/>    <meta name="dcterms.created" content="Wed, 21 Nov 2012 07:36:16 GMT"/>    <meta name="description" content=""/>    <meta name="keywords" content=""/>    <title>EMunching</title>	<link rel="stylesheet" href="/css/style.css" type="text/css"/>    <!--[if IE]>    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>    <![endif]-->
    </script>
    <script type="text/javascript" src="/js/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.10.0/jquery.validate.min.js"></script>
    <script type="text/javascript">
        jQuery(document).ready(function () {

            jQuery("#contactForm").validate({
                rules: {
                    knowMoreName: "required",
                    knowMoreEMail: {
                        required: true,
                        email: true
                    }
                },
                messages: {
                    knowMoreName: "&nbsp;",
                    knowMoreEMail: {
                        required: "&nbsp;",
                        email: "&nbsp;"
                    }
                }
            })

            jQuery("#submit").click(function (evt) {
                jQuery("#phoneError").hide();
                jQuery(".errorImage").remove();
                // Validate the form and retain the result.
                var isValid = jQuery("#contactForm").valid();
                var countryCode = jQuery("#knowMoreContactCountry").val();
                var areaCode = jQuery("#knowMoreContactArea").val()
                var contactNumber = jQuery("#knowMoreContactNumber").val()

                if (!/^[0-9-()]+$/.test(countryCode) || !/^[0-9-()+]+$/.test(areaCode) || !/^[0-9-()]+$/.test(contactNumber)) {
                    isValid = false;
                    jQuery("#phoneError").show();
                }
                // If the form didn't validate, prevent the
                //  form submission.
                if (!isValid)
                    evt.preventDefault();
            });
        });
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
<body>
    <div id="pageBody">		<div class="table" id="pageBodyContent">			<div class="tr" id="top">				<div id="topLeft" class="td">					<span id="gallaryTitle">An individually branded smartphone <br>app for your restaurant</span>					<div id="gallary">&nbsp;</div>				</div>				<div id="topRight" class="td">					<div id="logo" style="height: 57px; text-align: right; width: 100%;">						<img alt="logo" src="images/Campaign/eMunching_logo.png"/>					</div>					<div id="points">						<div id="pointsLeft">							<div id="point1" class="pointSection"><span class="pointNumber">&nbsp;</span><span class="pointText">PUSH<br>NOTIFICATIONS</span></div>							<div id="point3" class="pointSection"><span class="pointNumber">&nbsp;</span><span class="pointText">CUSTOMISED<br>PLATFORM</span></div>							<div id="point5" class="pointSection"><span class="pointNumber">&nbsp;</span><span class="pointText">INSTANT<br>ORDERING</span></div>							<div id="point7" class="pointSection"><span class="pointNumber">&nbsp;</span><span class="pointText">ACCESS TO<br>REVIEWS</span></div>						</div>						<div id="pointsRight">							<div id="point2" class="pointSection"><span class="pointNumber">&nbsp;</span><span class="pointText">NO UPFRONT<br>COMMITMENT</span></div>							<div id="point4" class="pointSection"><span class="pointNumber">&nbsp;</span><span class="pointText">PERSONALISED<br>COMMUNICATION</span></div>							<div id="point6" class="pointSection"><span class="pointNumber">&nbsp;</span><span class="pointText">SOCIAL MEDIA<br>CONNECTIVITY</span></div>							<div id="point8" class="pointSection"><span class="pointNumber">&nbsp;</span><span class="pointText">EFFECTIVE LOYALTY<br>MODULE</span></div>						</div>					</div>					<div id="viewDemoSection">						<div id="viewDemoButton">							<a href="http://www.emunching.com/TourDemo.htm">&nbsp;</a>						</div>					</div>				</div>			</div>            <div id="campaignErrorMsg"><asp:Label ID="errorMsg" runat="server"/></div>			<div class="tr" id="bottom">				<div id="bottomLeft" class="td">					<div id="formTitle">						<span>Want to know <span>more</span>?</span>					</div>					<div id="formTable">						<form name="contactForm" runat="server" id="contactForm">							<div class="formTR">                                <asp:Label CssClass="formLable" Text="Name:" runat="server" />                                <asp:TextBox ID="knowMoreName" runat="server" cssclass="formInput required"></asp:TextBox>							</div>							<div class="formTR">                                <asp:Label ID="Label1" CssClass="formLable" Text="E-mail:" runat="server" />                                <asp:TextBox ID="knowMoreEMail" runat="server" cssclass="formInput required"></asp:TextBox>							</div>							<div class="formTR">                                <asp:Label ID="Label2" CssClass="formLable" Text="Restaurant Name (Optional):" runat="server" />                                <asp:TextBox ID="knowMoreRestName" runat="server" cssclass="formInput"></asp:TextBox>							</div>                            <div class="formTR">                                <asp:Label ID="Label3" CssClass="formLable" Text="Contact Number:" runat="server" />                                <asp:TextBox ID="knowMoreContactCountry" runat="server" CssClass="formInput"></asp:TextBox>                                <asp:Label ID="Label4" Text="-" runat="server" />                                <asp:TextBox ID="knowMoreContactArea" runat="server" CssClass="formInput"></asp:TextBox>                                <asp:Label ID="Label5" Text="-" runat="server" />                                <asp:TextBox ID="knowMoreContactNumber" runat="server" CssClass="formInput"></asp:TextBox>                                <label for="knowMoreContact" class="error" id="phoneError">&nbsp;</label>                                <div id="contactInfoContainer"><span>(Country Code)</span><span>(Area Code)</span><span>(Number)</span></div>							</div>                            <div class="formTR">                                <asp:Label ID="Label6" CssClass="formLable" Text="Comments:" runat="server" />                                <asp:TextBox ID="knowMoreComments" TextMode="MultiLine" Columns="23" Rows="2" runat="server" CssClass="formInputArea"></asp:TextBox>                            </div>							<div class="formTR">                                <asp:Button Text="Submit" CssClass="formSubmit" runat="server" 
                                    onclick="submit_Click" ID="submit"/>							</div>						</form>					</div>				</div>				<div id="bottomRight" class="td">					<div id="contactHead">						<span>Contact us</span>					</div>					<div id="contactIcon">						<img alt="contact" src="images/Campaign/phone_mail_icon.png"/>					</div>					<div id="infoBoard">						<img src="images/Campaign/glassBoard.png" />						<span class="first">(U.S) : +1 347 497 6929</span>						<a href="mailto:info@emunching.com">info@emunching.com</a>                        <a href="http://www.emunching.com" >www.emunching.com</a>					</div>				</div>			</div>		</div>	</div>
</body>
</html>
