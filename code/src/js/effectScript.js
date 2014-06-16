// Emunching Dynamic Script Starts 

jQuery.noConflict();

// Terms and conditions Pop up

var popupStatus = 0;
function loadPopup()
{
	if(popupStatus == 0)
	{
		jQuery('#backgroundPopup').css({'opacity':'0.6'});
		jQuery('#backgroundPopup').fadeIn('slow');
		jQuery('#popupTermsContainer').fadeIn('slow');
		jQuery('#popupTermsContainerWrapper').load('terms-conditions.html #popupTermsContent');
		popupStatus = 1;
	}
	
}

function disablePopup()
{
	if(popupStatus == 1)
	{
		jQuery('#backgroundPopup').fadeOut('slow');
		jQuery('#popupTermsContainer').fadeOut('slow');
		popupStatus = 0;
	}
	
}

function centerPopup()
{
	var windowWidth = document.documentElement.clientWidth;
	var windowHeight = document.documentElement.clientHeight;
	var popupWidth = jQuery('#popupTermsContainer').width();
	var popupHeight = jQuery('#popupTermsContainer').height();
	jQuery('#popupTermsContainer').css({
		'position':'fixed',
		'top':'45px',
		'left':'350px'
	});	
	
}

// About Us Pop Up

var popupAboutStatus = 0;

function loadAboutPopup() {
	if(popupAboutStatus == 0){
		jQuery('#backgroundPopup').css({'opacity':'0.6'});
		jQuery('#popupAboutContainer').fadeIn('slow');
		jQuery('#backgroundPopup').fadeIn('slow');		
		jQuery('#popupAboutContainerWrapper').load('about.html #popupAboutContent');
		popupAboutStatus = 1;
		
	}
}

function disableAboutPopup() {
	if(popupAboutStatus == 1) {
		jQuery('#backgroundPopup').fadeOut('slow');
		jQuery('#popupAboutContainer').fadeOut('slow');
		popupAboutStatus = 0;		
	}
	
}

function centerAboutPopup() {
	var popupAboutWidth = jQuery('#popupAboutContainer').width();
	var popupAboutHeight = jQuery('#popupAboutContainer').height();
	jQuery('#popupAboutContainer').css({
		'position':'fixed',
		'top':'45px',
		'left':'350px'
	})	
	
}

// Pricing Pop Up

var popupPricingStatus = 0;

function loadPricingPopup() {
	if(popupPricingStatus == 0) {
		jQuery('#backgroundPopup').css('opacity','0.6');
		jQuery('#popupPricingContainer').fadeIn('slow');
		jQuery('#backgroundPopup').fadeIn('slow');
		jQuery('#popupPricingContainerWrapper').load('pricing.html #popupPricingContent');
		popupPricingStatus = 1;
	}	
}

function disablePricingPopup() {
	if(popupPricingStatus == 1) {
		jQuery('#backgroundPopup').fadeOut('slow');
		jQuery('#popupPricingContainer').fadeOut('slow');
		popupPricingStatus = 0;
	}
}

function centerPricingPopup() {
	var popupPricingWidth = jQuery('#popupPricingContainer').width();
	var popupPricingHeight = jQuery('#popupPricingContainer').height();
	jQuery('#popupPricingContainer').css({
		'position':'fixed',
		'top':'45px',
		'left':'350px'		
	});
}

// Popup Admin Panel starts

var popupAdminStatus = 0;

function loadAdminPopup() {
if(popupAdminStatus == 0) {
	jQuery('#backgroundPopup').css({'opacity':0.6});
	jQuery('#backgroundPopup').fadeIn('slow');
	jQuery('#popupAdminContainer').fadeIn('slow');
	jQuery('#popupAdminContainerWrapper').load('admin.html #popupAdminContent');
	popupAdminStatus = 1;
          }
}

function disableAdminPopup() {
	if(popupAdminStatus == 1){
		jQuery('#backgroundPopup').fadeOut('slow');
		jQuery('#popupAdminContainer').fadeOut('slow');
		popupAdminStatus = 0;
	}
}

function centerAdminPopup(){
	var popupAdminWidth = jQuery('#popupAdminContainer').width();
	var popupAdminHeight = jQuery('#popupAdminContainer').height();
	jQuery('#popupAdminContainer').css({
		'position':'absolute',
		'top':'20px',
		'left':'100px'	
	});
	
}

// Popup Iphone starts

var popupIphoneStatus = 0;

function loadIphonePopup() {
if(popupIphoneStatus == 0) {
	jQuery('#backgroundPopup').css({'opacity':0.6});
	jQuery('#backgroundPopup').fadeIn('slow');
	jQuery('#popupIphoneContainer').fadeIn('slow');	
	popupIphoneStatus = 1;
          }
}

function disableIphonePopup() {
	if(popupIphoneStatus == 1){
		jQuery('#backgroundPopup').fadeOut('slow');
		jQuery('#popupIphoneContainer').fadeOut('slow');
		popupIphoneStatus = 0;
	}
}

function centerIphonePopup(){
	var popupIphoneWidth = jQuery('#popupIphoneContainer').width();
	var popupIphoneHeight = jQuery('#popupIphoneContainer').height();
	jQuery('#popupIphoneContainer').css({
		'position':'absolute',
		'top':'20px',
		'left':'100px'	
	});
	
}

// Animation and click events
jQuery(document).ready(function () {

    var hash = window.location.hash.substring(1);
    //var hash = url.substring(url.indexOf("#") + 1);
    if (hash == "tourTab-theme") {
        loadIphonePopup();
        centerIphonePopup();
    }

    jQuery('#ivlogo').bind('mouseover', function () {
        jQuery('#logo').animate({
            top: '-20px'
        });

    });
    jQuery('#ivlogo').bind('mouseout', function () {
        jQuery('#logo').animate({
            top: '20px'
        });

    });

    //Customized Check Box

    jQuery('.checkBox, .checkBoxClear').bind('click', function () {
        if (jQuery(this).hasClass('checkBox')) {
            jQuery(this).addClass('checkBoxClear');
            jQuery(this).removeClass('checkBox');
            jQuery("#chk1").attr("checked", "checked");
        }
        else {
            jQuery(this).addClass('checkBox');
            jQuery(this).removeClass('checkBoxClear');
            jQuery("#chk1").removeAttr("checked");
        }

    });



    /*jQuery('#signupForm div input').blur(function() {
    if(jQuery('#signupForm div input:eq(2)').val().length!='')
    {
    jQuery('#slideScreen').slideDown('slow'); 
    }
    else
    {
    jQuery('#slideScreen').slideUp('slow'); 
    }
		
    });*/


    jQuery('#signupForm div#more img').bind('click', function () {
        jQuery('#signupForm div:lt(3)').hide();
        jQuery('#signupForm div:gt(2)').show();
        jQuery('#signupForm div#more').hide();
    });

    jQuery('#signupForm div#back img').bind('click', function () {
        jQuery('#signupForm div').show();
        jQuery('#signupForm div:eq(3)').hide();
        jQuery('#signupForm div:eq(4)').hide();
        jQuery('#signupForm div#back').hide();
    });

    /*jQuery('#signupForm #btnsubmit').click(function()
    {	
        
    if(jQuery('#signupForm div.checkBox').hasClass('checkBox'))
    {
    alert('Please Agree to Terms and Conditions');
    }
    else
    {
    SubmitButton_Click();
    }
    });*/

    jQuery('.btnActive, .btnHover').bind('click', function () {
        if (jQuery(this).hasClass('btnActive')) {
            jQuery(this).addClass('btnHover');
            jQuery(this).removeClass('btnActive');
        }
        else {
            jQuery(this).addClass('btnActive');
            jQuery(this).removeClass('btnHover');
        }

    });

    // Events for Terms and Conditions

    jQuery('#terms').click(function () {
        loadPopup();
        centerPopup();
    });

    jQuery('#close').click(function () {
        disablePopup();
    });

    jQuery('#backgroundPopup').click(function () {
        disablePopup();
    });

    jQuery(document).bind('keydown', function (e) {
        if (e.which == 27) {
            disablePopup();
        }

    });

    // Events for Terms and Conditions Ends

    // Events For About Us

    jQuery('#menu ul li:eq(2)').bind('click', function () {
        loadAboutPopup();
        centerAboutPopup();
    });

    jQuery('#backgroundPopup').click(function () {
        disableAboutPopup();
    });

    jQuery('#closex').click(function () {
        disableAboutPopup();
    });

    jQuery(document).bind('keydown', function (e) {
        if (e.which == 27) {
            disableAboutPopup();
        }

    });


    // Events for Pricing Starts

    jQuery('#menu ul li:eq(3)').bind('click', function () {
        loadPricingPopup();
        centerPricingPopup();
    });

    jQuery('#backgroundPopup').click(function () {
        disablePricingPopup();
    });

    jQuery('#closey').click(function () {
        disablePricingPopup();
    });

    jQuery(document).bind('keydown', function (e) {
        if (e.which == 27) {
            disablePricingPopup();
        }

    });

    // Events for Pricing Ends


    // Events for Admin Popup

    jQuery('#tourTab-admin').bind('click', function () {
        loadAdminPopup();
        centerAdminPopup();

    });

    jQuery('#backgroundPopup').bind('click', function () {
        disableAdminPopup();

    });

    jQuery('#closez').bind('click', function () {
        disableAdminPopup();
    });

    jQuery(document).bind('keydown', function (e) {
        if (e.which == 27) {
            disableAdminPopup();
        }
    });


    // Event for Iphone Popup

    jQuery('#tourTab-theme').bind("click", function () {
        loadIphonePopup();
        centerIphonePopup();
    });

    jQuery("#backgroundPopup").bind("click", function () {
        disableIphonePopup();
    });

    jQuery("#close").bind("click", function () {
        disableIphonePopup();
    });

    jQuery(document).bind("keydown", function (e) {
        if (e.which == 27) {
            disableIphonePopup();
        }
    });

    jQuery('#tourTabnav li').bind('click', function () {
        jQuery(this).addClass('active').siblings().removeClass('active');

    });


    jQuery('#tourTabnav ul li a').click(function (e) {
        e.preventDefault();
        jQuery('#tourTabnav-image-container img').attr('src', 'images/' + this.hash.substring(1) + '.jpg');

    });

    jQuery('#take-tour img').slideDown('slow');
});

// Script for Iphone - Beige screen slideshow

jQuery(document).ready(function() {
	jQuery('.Beigeslider img:first').addClass('active');
	
	var imageWidth = jQuery('.iphoneBeigeVisible').width();
	var totalImage = jQuery('.Beigeslider img').size();
	var slideWidth = imageWidth * totalImage;
	jQuery('.Beigeslider').css({'width':slideWidth});
	
	jQuery('.next-beige').bind('click', function() {
		jQueryactive = jQuery('.Beigeslider img.active').next();
		if(jQueryactive.length == 0) {
			jQueryactive = jQuery('.Beigeslider img:first');
		}
		jQuery('.Beigeslider img').removeClass('active');
		jQueryactive.addClass('active');
		
		var count = jQueryactive.attr('alt') -1;
		var slidePosition = count * imageWidth;
		jQuery('.Beigeslider').animate({'left': -slidePosition}, 500);
	});
	
	jQuery('.prev-beige').bind('click', function() {
		jQueryactive = jQuery('.Beigeslider img.active').prev();
		if(jQueryactive.length == 0) {
			jQueryactive = jQuery('.Beigeslider img:last');
		}
		jQuery('.Beigeslider img').removeClass('active');
		jQueryactive.addClass('active');
		
		var count = jQueryactive.attr('alt') -1;
		var slidePosition = count * imageWidth;
		jQuery('.Beigeslider').animate({'left': -slidePosition}, 500);
	});
	
});


// Script for Iphone - Pista screen slideshow

jQuery(document).ready(function() {
	jQuery('.Pistaslider img:first').addClass('active');
	
	var imageWidth = jQuery('.iphonePistaVisible').width();
	var totalImage = jQuery('.Pistaslider img').size();
	var slideWidth = imageWidth * totalImage;
	jQuery('.Pistaslider').css({'width':slideWidth});
	
	jQuery('.next-pista').bind('click', function() {
		jQueryactive = jQuery('.Pistaslider img.active').next();
		if(jQueryactive.length == 0) {
			jQueryactive = jQuery('.Pistaslider img:first');
		}
		jQuery('.Pistaslider img').removeClass('active');
		jQueryactive.addClass('active');
		
		var count = jQueryactive.attr('alt') -1;
		var slidePosition = count * imageWidth;
		jQuery('.Pistaslider').animate({'left': -slidePosition}, 500);
	});
	
	jQuery('.prev-pista').bind('click', function() {
		jQueryactive = jQuery('.Pistaslider img.active').prev();
		if(jQueryactive.length == 0) {
			jQueryactive = jQuery('.Pistaslider img:last');
		}
		jQuery('.Pistaslider img').removeClass('active');
		jQueryactive.addClass('active');
		
		var count = jQueryactive.attr('alt') -1;
		var slidePosition = count * imageWidth;
		jQuery('.Pistaslider').animate({'left': -slidePosition}, 500);
	});
	
	jQuery(".downloadIcon").mouseenter(function(){
		jQuery(this).children('a').children('img').attr('src','images/download-app-on.png');
	});
	jQuery(".downloadIcon").mouseleave(function(){
		jQuery(this).children('a').children('img').attr('src','images/download-app.png');
	});
});