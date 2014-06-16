<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript" src="/js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/js/jquery.smartWizard.js"></script>
<script type="text/javascript">
   
    $(document).ready(function(){
    	// Smart Wizard     	
  		$('#wizard').smartWizard({transitionEffect:'slideleft',onLeaveStep:leaveAStepCallback,onFinish:onFinishCallback,enableFinishButton:true});

      function leaveAStepCallback(obj){
        var step_num= obj.attr('rel');
        return validateSteps(step_num);
      }
      
      function onFinishCallback(){
       if(validateAllSteps()){
        $('form').submit();
       }
      }
            
		});
	   
    function validateAllSteps(){
       var isStepValid = true;
       
       if(validateStep1() == false){
         isStepValid = false;
         $('#wizard').smartWizard('setError',{stepnum:1,iserror:true});         
       }else{
         $('#wizard').smartWizard('setError',{stepnum:1,iserror:false});
       }
       
       if(validateStep3() == false){
         isStepValid = false;
         $('#wizard').smartWizard('setError',{stepnum:3,iserror:true});         
       }else{
         $('#wizard').smartWizard('setError',{stepnum:3,iserror:false});
       }
       
       if(!isStepValid){
          $('#wizard').smartWizard('showMessage','Please correct the errors in the steps and continue');
       }
              
       return isStepValid;
    } 	
		
		
		function validateSteps(step){
		  var isStepValid = true;
      // validate step 1
      if(step == 1){
        if(validateStep1() == false ){
          isStepValid = false; 
          $('#wizard').smartWizard('showMessage','Please correct the errors in step'+step+ ' and click next.');
          $('#wizard').smartWizard('setError',{stepnum:step,iserror:true});         
        }else{
          $('#wizard').smartWizard('setError',{stepnum:step,iserror:false});
        }
      }
      
      // validate step3
      if(step == 3){
        if(validateStep3() == false ){
          isStepValid = false; 
          $('#wizard').smartWizard('showMessage','Please correct the errors in step'+step+ ' and click next.');
          $('#wizard').smartWizard('setError',{stepnum:step,iserror:true});         
        }else{
          $('#wizard').smartWizard('setError',{stepnum:step,iserror:false});
        }
      }
      
      return isStepValid;
    }
		
		function validateStep1(){
       var isValid = true; 
       // Validate Username
       var un = $('#username').val();
       if(!un && un.length <= 0){
         isValid = false;
         $('#msg_username').html('Please fill username').show();
       }else{
         $('#msg_username').html('').hide();
       }
       
       // validate password
       var pw = $('#password').val();
       if(!pw && pw.length <= 0){
         isValid = false;
         $('#msg_password').html('Please fill password').show();         
       }else{
         $('#msg_password').html('').hide();
       }
       
       // validate confirm password
       var cpw = $('#cpassword').val();
       if(!cpw && cpw.length <= 0){
         isValid = false;
         $('#msg_cpassword').html('Please fill confirm password').show();         
       }else{
         $('#msg_cpassword').html('').hide();
       }  
       
       // validate password match
       if(pw && pw.length > 0 && cpw && cpw.length > 0){
         if(pw != cpw){
           isValid = false;
           $('#msg_cpassword').html('Password mismatch').show();            
         }else{
           $('#msg_cpassword').html('').hide();
         }
       }
       return isValid;
    }
    
    function validateStep3(){
      var isValid = true;    
      //validate email  email
      var email = $('#email').val();
       if(email && email.length > 0){
         if(!isValidEmailAddress(email)){
           isValid = false;
           $('#msg_email').html('Email is invalid').show();           
         }else{
          $('#msg_email').html('').hide();
         }
       }else{
         isValid = false;
         $('#msg_email').html('Please enter email').show();
       }       
      return isValid;
    }
    
    // Email Validation
    function isValidEmailAddress(emailAddress) {
      var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
      return pattern.test(emailAddress);
    } 
		
		
</script>

<style type="text/css">
/*   
  SmartWizard 2.0 plugin 
  jQuery Wizard control Plugin
  by Dipu
  
  http://www.techlaboratory.net
  http://tech-laboratory.blogspot.com
*/
.swMain {
  position:relative;
  display:block;
  margin:0;
  padding:0;
  border: 0px solid #CCC;
  overflow:visible;
  float:left;
  width:980px;
}
.swMain .stepContainer {
  display:block;
  position: relative;
  margin: 0;
  padding:0;    
  border: 0px solid #CCC;    
  overflow:hidden;
  clear:both;
  height:300px;
}

.swMain .stepContainer div.content {
  display:block;
  position: absolute;  
  float:left;
  margin: 0;
  padding:5px;    
  border: 1px solid #CCC; 
  font: normal 12px Verdana, Arial, Helvetica, sans-serif; 
  color:#5A5655;   
  background-color:#F8F8F8;  
  height:300px;
  text-align:left;
  overflow:visible;    
  z-index:88; 
  -webkit-border-radius: 5px;
  -moz-border-radius  : 5px;
  width:968px;
  clear:both;
}

.swMain div.actionBar {
  display:block;
  position: relative; 
  clear:both;
  margin:             3px 0 0 0;   
  border:             1px solid #CCC;
  padding:            0;    
  color:              #5A5655;   
  background-color:   #F8F8F8;
  height:40px;
  text-align:left;
  overflow:auto;    
  z-index:88; 

  -webkit-border-radius: 5px;
  -moz-border-radius  : 5px;
  left:0;
}

.swMain .stepContainer .StepTitle {
  display:block;
  position: relative;
  margin:0;   
  border:1px solid #E0E0E0;
  padding:5px;   
  font: bold 16px Verdana, Arial, Helvetica, sans-serif; 
  color:#5A5655;   
  background-color:#E0E0E0;
  clear:both;
  text-align:left; 
  z-index:88;
  -webkit-border-radius: 5px;
  -moz-border-radius  : 5px;    
}
.swMain ul.anchor {
  position: relative;
  display:block;
  float:left;
  list-style: none;
  padding: 0px;  
  margin: 10px 0;      
  clear: both;
  border: 0px solid #CCCCCC;    
  background: transparent; /*#EEEEEE */
}
.swMain ul.anchor li{ 
  position: relative; 
  display:block;
  margin: 0;
  padding: 0; 
  padding-left:3px;
  padding-right: 3px;
  border: 0px solid #E0E0E0;      
  float: left;
}
/* Anchor Element Style */
.swMain ul.anchor li a {
  display:block;
  position:relative;
  float:left;
  margin:0;
  padding:3px;
  height:60px;
  width:230px;
  text-decoration: none;
  outline-style:none;
  -moz-border-radius  : 5px;
  -webkit-border-radius: 5px;
  z-index:99;
}
.swMain ul.anchor li a .stepNumber{
  position:relative;
  float:left;
  width:30px;
  text-align: center;
  padding:5px;
  padding-top:0;
  font: bold 45px Verdana, Arial, Helvetica, sans-serif;
}
.swMain ul.anchor li a .stepDesc{
  position:relative;
  display:block;
  float:left;
  text-align: left;
  padding:5px;

  font: bold 20px Verdana, Arial, Helvetica, sans-serif;
}
.swMain ul.anchor li a .stepDesc small{
  font: normal 12px Verdana, Arial, Helvetica, sans-serif;
}
.swMain ul.anchor li a.selected{
  color:#F8F8F8;
  background: #EA8511;  /* EA8511 */
  border: 1px solid #EA8511;
  cursor:text;
  -moz-box-shadow: 5px 5px 8px #888;
  -webkit-box-shadow: 5px 5px 8px #888;
  box-shadow: 5px 5px 8px #888;
}
.swMain ul.anchor li a.selected:hover {
  color:#F8F8F8;  
  background: #EA8511;  
}

.swMain ul.anchor li a.done { 
  position:relative;
  color:#FFF;  
  background: #8CC63F;  
  border: 1px solid #8CC63F;   
  z-index:99;
}
.swMain ul.anchor li a.done:hover {
  color:#5A5655;  
  background: #8CC63F; 
  border: 1px solid #5A5655;   
}
.swMain ul.anchor li a.disabled {
  color:#CCCCCC;  
  background: #F8F8F8;
  border: 1px solid #CCC;  
  cursor:text;   
}
.swMain ul.anchor li a.disabled:hover {
  color:#CCCCCC;  
  background: #F8F8F8;     
}

.swMain ul.anchor li a.error {
  color:#6c6c6c !important;  
  background: #f08f75 !important;
  border: 1px solid #fb3500 !important;      
}
.swMain ul.anchor li a.error:hover {
  color:#000 !important;       
}

.swMain .buttonNext {
  display:block;
  float:right;
  margin:5px 3px 0 3px;
  padding:5px;
  text-decoration: none;
  text-align: center;
  font: bold 13px Verdana, Arial, Helvetica, sans-serif;
  width:100px;
  color:#FFF;
  outline-style:none;
  background-color:   #5A5655;
  border: 1px solid #5A5655;
  -moz-border-radius  : 5px; 
  -webkit-border-radius: 5px;    
}
.swMain .buttonDisabled {
  color:#F8F8F8  !important;
  background-color: #CCCCCC !important;
  border: 1px solid #CCCCCC  !important;
  cursor:text;    
}
.swMain .buttonPrevious {
  display:block;
  float:right;
  margin:5px 3px 0 3px;
  padding:5px;
  text-decoration: none;
  text-align: center;
  font: bold 13px Verdana, Arial, Helvetica, sans-serif;
  width:100px;
  color:#FFF;
  outline-style:none;
  background-color:   #5A5655;
  border: 1px solid #5A5655;
  -moz-border-radius  : 5px; 
  -webkit-border-radius: 5px;    
}
.swMain .buttonFinish {
  display:block;
  float:right;
  margin:5px 10px 0 3px;
  padding:5px;
  text-decoration: none;
  text-align: center;
  font: bold 13px Verdana, Arial, Helvetica, sans-serif;
  width:100px;
  color:#FFF;
  outline-style:none;
  background-color:   #5A5655;
  border: 1px solid #5A5655;
  -moz-border-radius  : 5px; 
  -webkit-border-radius: 5px;    
}

/* Form Styles */

.txtBox {
  border:1px solid #CCCCCC;
  color:#5A5655;
  font:13px Verdana,Arial,Helvetica,sans-serif;
  padding:2px;
  width:430px;
}
.txtBox:focus {
  border:1px solid #EA8511;
}

.swMain .loader {
  position:relative;  
  display:none;
  float:left;  
  margin: 2px 0 0 2px;
  padding:8px 10px 8px 40px;
  border: 1px solid #FFD700; 
  font: bold 13px Verdana, Arial, Helvetica, sans-serif; 
  color:#5A5655;       
  background: #FFF url(/images/loader.gif) no-repeat 5px;  
  -moz-border-radius  : 5px;
  -webkit-border-radius: 5px;
  z-index:998;
}
.swMain .msgBox {
  position:relative;  
  display:none;
  float:left;
  margin: 4px 0 0 5px;
  padding:5px;
  border: 1px solid #FFD700; 
  background-color: #FFFFDD;  
  font: normal 12px Verdana, Arial, Helvetica, sans-serif; 
  color:#5A5655;         
  -moz-border-radius  : 5px;
  -webkit-border-radius: 5px;
  z-index:999;
  min-width:200px;  
}
.swMain .msgBox .content {
  font: normal 12px Verdana,Arial,Helvetica,sans-serif;
  padding: 0px;
  float:left;
}
.swMain .msgBox .close {
  border: 1px solid #CCC;
  border-radius: 3px;
  color: #CCC;
  display: block;
  float: right;
  margin: 0 0 0 5px;
  outline-style: none;
  padding: 0 2px 0 2px;
  position: relative;
  text-align: center;
  text-decoration: none;
}
.swMain .msgBox .close:hover{
  color: #EA8511;
  border: 1px solid #EA8511;  
}
</style>
</head><body>

<table align="center" border="0" cellpadding="0" cellspacing="0">
<tr><td> 
<form action="#" method="POST">
  <input type='hidden' name="issubmit" value="1">
<!-- Tabs -->
  		<div id="wizard" class="swMain">
  			<ul>
  				<li><a href="#step-1">
                <label class="stepNumber">1</label>
                <span class="stepDesc">
                   Account Details<br />
                   <small>Fill your account details</small>
                </span>
            </a></li>
  				<li><a href="#step-2">
                <label class="stepNumber">2</label>
                <span class="stepDesc">
                   Profile Details<br />
                   <small>Fill your profile details</small>
                </span>
            </a></li>
  				<li><a href="#step-3">
                <label class="stepNumber">3</label>
                <span class="stepDesc">
                   Contact Details<br />
                   <small>Fill your contact details</small>
                </span>
             </a></li>
  				<li><a href="#step-4">
                <label class="stepNumber">3</label>
                <span class="stepDesc">
                   Other Details<br />
                   <small>Fill your other details</small>
                </span>
            </a></li>
  			</ul>
  			<div id="step-1">	
            <h2 class="StepTitle">Step 1: Account Details</h2>
            <table cellspacing="3" cellpadding="3" align="center">
          			<tr>
                    	<td align="center" colspan="3">&nbsp;</td>
          			</tr>        
          			<tr>
                    	<td align="right">Username :</td>
                    	<td align="left">
                    	  <input type="text" id="username" name="username" value="" class="txtBox">
                      </td>
                    	<td align="left"><span id="msg_username"></span>&nbsp;</td>
          			</tr>
          			<tr>
                    	<td align="right">Password :</td>
                    	<td align="left">
                    	  <input type="password" id="password" name="password" value="" class="txtBox">
                      </td>
                    	<td align="left"><span id="msg_password"></span>&nbsp;</td>
          			</tr> 
                <tr>
                    	<td align="right">Confirm Password :</td>
                    	<td align="left">
                    	  <input type="password" id="cpassword" name="cpassword" value="" class="txtBox">
                      </td>
                    	<td align="left"><span id="msg_cpassword"></span>&nbsp;</td>
          			</tr>                                   			
  			   </table>          			
        </div>
  			<div id="step-2">
            <h2 class="StepTitle">Step 2: Profile Details</h2>	
            <table cellspacing="3" cellpadding="3" align="center">
          			<tr>
                    	<td align="center" colspan="3">&nbsp;</td>
          			</tr>        
          			<tr>
                    	<td align="right">First Name :</td>
                    	<td align="left">
                    	  <input type="text" id="firstname" name="firstname" value="" class="txtBox">
                      </td>
                    	<td align="left"><span id="msg_firstname"></span>&nbsp;</td>
          			</tr>
          			<tr>
                    	<td align="right">Last Name :</td>
                    	<td align="left">
                    	  <input type="text" id="lastname" name="lastname" value="" class="txtBox">
                      </td>
                    	<td align="left"><span id="msg_lastname"></span>&nbsp;</td>
          			</tr> 
          			<tr>
                    	<td align="right">Gender :</td>
                    	<td align="left">
                        <select id="gender" name="gender" class="txtBox">
                          <option value="">-select-</option>
                          <option value="Female">Female</option>
                          <option value="Male">Male</option>                 
                        </select>
                      </td>
                    	<td align="left"><span id="msg_gender"></span>&nbsp;</td>
          			</tr>                                   			
  			   </table>        
        </div>                      
  			<div id="step-3">
            <h2 class="StepTitle">Step 3: Contact Details</h2>	
            <table cellspacing="3" cellpadding="3" align="center">
          			<tr>
                    	<td align="center" colspan="3">&nbsp;</td>
          			</tr>        
          			<tr>
                    	<td align="right">Email :</td>
                    	<td align="left">
                    	  <input type="text" id="email" name="email" value="" class="txtBox">
                      </td>
                    	<td align="left"><span id="msg_email"></span>&nbsp;</td>
          			</tr>
          			<tr>
                    	<td align="right">Phone :</td>
                    	<td align="left">
                    	  <input type="text" id="phone" name="phone" value="" class="txtBox">
                      </td>
                    	<td align="left"><span id="msg_phone"></span>&nbsp;</td>
          			</tr>          			
          			<tr>
                    	<td align="right">Address :</td>
                    	<td align="left">
                            <textarea name="address" id="address" class="txtBox" rows="3"></textarea>
                      </td>
                    	<td align="left"><span id="msg_address"></span>&nbsp;</td>
          			</tr>                                   			
  			   </table>               				          
        </div>
  			<div id="step-4">
            <h2 class="StepTitle">Step 4: Other Details</h2>	
            <table cellspacing="3" cellpadding="3" align="center">
          			<tr>
                    	<td align="center" colspan="3">&nbsp;</td>
          			</tr>        
          			<tr>
                    	<td align="right">Hobbies :</td>
                    	<td align="left">
                    	  <input type="text" id="phone" name="phone" value="" class="txtBox">
                      </td>
                    	<td align="left"><span id="msg_phone"></span>&nbsp;</td>
          			</tr>          			
          			<tr>
                    	<td align="right">About You :</td>
                    	<td align="left">
                            <textarea name="address" id="address" class="txtBox" rows="5"></textarea>
                      </td>
                    	<td align="left"><span id="msg_address"></span>&nbsp;</td>
          			</tr>                                   			
  			   </table>                 			
        </div>
  		</div>
<!-- End SmartWizard Content -->  		
</form> 
  		
</td></tr>
</table> 

</body>
</html>
