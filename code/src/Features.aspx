﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Features.aspx.cs" Inherits="Features" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8"/>
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
    <div id="pageBody">
                                    onclick="submit_Click" ID="submit"/>
</body>
</html>