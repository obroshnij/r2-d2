var mysql=false;
var cpu=false;
var memory=false;
var ep=false;
var io=false;

var div=document.getElementById("output");

function generate () {
  var text;
       
  var warning=document.getElementById("warning").checked;
  var suspend=document.getElementById("suspend").checked;
  
  var user=document.getElementById("user").value;
  var domain=document.getElementById("domain").value;
  var server=document.getElementById("server").value;
  var upgrade=document.getElementById("upgrade").value;
  
  if (!(warning||suspend)) {alert ("Select action type (Warning/Suspend)"); return;};    
 
  if (warning) {text = "WARNING: Resource abuse on account \'"+user+"\'";};
  if (suspend) {text = "IMPORTANT: account \'"+user+"\'";};
  
  if (domain.length > 0) {text = text + " ("+domain+")";};
  
  if (warning) {text = text + " - "+server+" <br><br>";};
  if (suspend) {text = text + " is suspended due to Resource abuse - "+server+" <br><br>";};
  
  text = text + "Hello, <br><br>It has come to our attention that "+user+" hosting account is using more than its fair share of the server resources, causing poor server performance for your account and for other users on the server. Unoptimized scripts, incorrectly configured crons, or a lot of simultaneous visitors are some possible causes of such load. You are welcome to refer to Terms of Service, paragraph 10 point 1 \"Server Resource Provision\": http://www.namecheap.com/legal/hosting/aup.aspx <br><br>";
  
  if (cpu||memory||ep||io) {text = text + "As we see the following limits are being exceeded: <br>";};
  if (cpu) {text = text + "CPU Usage<br>"};
  if (memory) {text = text + "Memory Usage<br>"};
  if (ep) {text = text + "Entry Processes<br>"};
  if (io) {text = text + "Input/Output<br>"};
  
  if (mysql) {text = text + "The server is being abused by MySQL queries.<br>";};
  
  text = text + "<br>";
  
  if (ep) {text = text + "Make sure there is no RSS enabled on your site. ";};
  
  if (cpu||memory||ep) {text = text + "Please consider turning off some unnecessary plugins and possibly change the theme. ";}
    
  if (io) {text = text + "Please be advised to have CloudFlare enabled (you may find the corresponding instruction at http://www.namecheap.com/support/knowledgebase/article.aspx/1191/176/ ). ";};
  
  if (cpu||memory||ep||mysql) {text = text + "It may make sense to enable caching plugins. But please note that sometimes these plugins, in conjunction with other site elements, may malfunction, creating serious load. If you use one, check if disabling reduces the load. We would also recommend to make sure that your site(s) are well optimized and function normally. If you have doubts, and you are not a developer or professional in sites administration, we recommend to take advantage of webmaster services.";};
  
  if (ep||mysql) {text = text + "<br>If SSH access is enabled for your account, ";};
  
  if (mysql) {text = text + " you can easily check which threads are processing by the MySQL server. First you will need to connect to your database. Please use the following command:<br>mysql -uusername -ppassword database_name<br>Once you connected to the database, please use the following command to see the threads running:<br>show full processlist;";};
  
  if (mysql&&ep) {text = text + "<br>You might also find what sites/pages are causing the load using \"top -c\" command. If you can see that it takes much time to process a single process or that they take a considerable amount of memory, then it make sense to disable it . Otherwise it may mean that your sites are receiving too much traffic/many hits. You may check it in Awstats in cPanel. In this case upgrade is the most often advised solution. ";}
    else {if (ep) {text = text + "you might also find what sites/pages are causing the load using \"top -c\" command. If you can see that it takes much time to process a single process or that they take a considerable amount of memory, then it make sense to disable it . Otherwise it may mean that your sites are receiving too much traffic/many hits. You may check it in Awstats in cPanel. In this case upgrade is the most often advised solution. ";};};
    
  text = text + "<br><br>You might also consider upgrading your account to "+upgrade+". All upgrades are processed on the prorate basis, thus you will need to pay only for the difference between two plans. <br><br> Please let us suggest you to refer to your cPanel and check the corresponding Resource Usage limits and statistics powered by the LVE technology. Additional information and instructions on how to use those features are available in our Knowledge Base article at https://www.namecheap.com/support/knowledgebase/subcategory.aspx/103/lve-cloudlinux <br><br>";
  
  if (warning) {text=text + "Kindly resolve the issue and update us with the actions taken within 24 hours in order to prevent suspension of the account reported. If we do not receive your response or if the issue is not resolved within the specified timeframe, we will be forced to suspend the account in order to prevent the resource abuse. Please also note that in case the negative effect on the server caused by the account activity grows, we may be forced to suspend the account in question immediately, to our regret. <br><br>";};
  if (suspend) {text=text + "To our regret we have been forced to suspend the reported account in order to prevent the resource abuse. In order to have the account unsuspended you will need to take actions necessary for resolving the issue immediately after unsuspension. <br><br>";};
  
  text = text + "Please let us know if you have any questions. You may find the details below: <br>";  
  
  if (mysql) {text = text + "<br>============================================ <br>" + document.getElementById("mysqlLogs").value;}; 
  
  if (cpu||memory||ep||io) {text = text + "<br>============================================ <br>" + document.getElementById("logs").value.replace(/\n/g, '<br>') + "<br>============================================<br>ID : LVE Id or username<br>aCPU : Average CPU usage<br>mCPU : Max CPU usage<br>lCPU : CPU Limit<br>aEP : Average Entry Processes<br>mEP : Max Entry Processes<br>lEP : maxEntryProc limit<br>aVMem : Average Virtual Memory Usage<br>mVMem : Max Virtual Memory Usage<br>lVMem : Virtual Memory Limit<br>VMemF : Out Of Memory Faults<br>EPf : Entry processes faults<br>aPMem : Average Physical Memory Usage<br>mPMem : Max Physical Memory Usage<br>lPMem : Physical Memory Limit<br>aNproc : Average Number of processes<br>mNproc : Max Number of processes<br>lNproc : Limit of Number of processes<br>PMemF : Out Of Physical Memory Faults<br>NprocF : Number of processes faults<br>aIO : Average I/O<br>mIO : Max I/O<br>lIO : I/O Limit";};
  
  div.innerHTML = text;
  div.style.display = '';
}

// HTML PDFier
// ---------------------------------------------------------------------------

var addPdfField = function() {
  var time = Date.now();
  var $row = $('<div></div>').attr('class', 'pdf-file-field row html-file-field');
  var $left = $('<div></div>').attr('class', 'large-9 columns');
  var $label = $('<label>PDF File</label>').attr('for', '_files_pdf' + time);
  var $fileField = $('<input></input>').attr('type', 'file').attr('id', '_files_pdf' + time).attr('name', '[files][pdf]' + time);
  $left.append($label).append($fileField);
  var $right = $('<div></div>').attr('class', 'large-3 columns');
  var $link = $('<a>Remove</a>').attr('onclick', 'removePdfField(this);').attr('class', 'right');
  $right.append($('<br>')).append($link);
  $row.append($left).append($right);
  $('.pdf-files').append($row);
}

var removePdfField = function(link) {
  $(link).closest('.pdf-file-field').remove();
}

var toggleHtmlFileField = function(checkbox) {
  var enabled = !$(checkbox).prop('checked');
  $(checkbox).closest('.html-file-field').find('input[type="file"]').attr('disabled', enabled).val('');
}

var validatePdfierForm = function() {
  errors = [];
  var fields = $("input[type='file']:not([disabled])").map(function(index, field){
    var type = $(field).attr('name').slice(8).split(']')[0];
    var name = $(field).closest('.html-file-field').find('label').text();
    var val;
    if ($(field).val().length > 0) {
      var array = $(field).val().split('.');
      val = array[array.length - 1];
    } else {
      val = 0;
    }
    return { type: type, name: name, val: val }
  }).each(function(index, el){
    if (el.val === 0) {
      errors.push(el.name + " can't be blank");
    } else if (el.type === 'pdf' && el.val !== 'pdf') {
      errors.push(el.name + " has invalid file uploaded");
    } else if (el.type === 'html' && !(el.val === 'html' || el.val === 'htm')) {
      errors.push(el.name + " has invalid file uploaded");
    }
  });
  return errors;
}

$(document).ready(function(){
  $('#pdfier-form').submit(function(event){
    errors = validatePdfierForm();
    if (errors[0]) {
      event.preventDefault();
      alert(errors.join("\n"));
    }
  });
});