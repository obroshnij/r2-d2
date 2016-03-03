$(document).ready(function(){
  $('#pdfier-form').submit(function(event){
    errors = validatePdfierForm();
    if (errors[0]) {
      event.preventDefault();
      toastr.error(errors.join('<br>'));
    }
  });
  window.mysql = false;
  window.cpu = false;
  window.memory = false;
  window.ep = false;
  window.io = false;
  window.div = document.getElementById("output");
});

var generate = function() {
  var text;
  
  var shared   = document.getElementById("shared").checked;
  var reseller = document.getElementById("reseller").checked;
       
  var warning = document.getElementById("warning").checked;
  var suspend = document.getElementById("suspend").checked;
  
  var user    = document.getElementById("user").value;
  var domain  = document.getElementById("domain").value;
  var server  = document.getElementById("server").value;
  var upgrade = document.getElementById("upgrade").value;
  var time    = document.getElementById("allow_time").value;
  
  if (!(shared||reseller)) {toastr.error("Select hosting type (Shared/Reseller)"); return;}
  
  if (!(warning||suspend)) {toastr.error("Select action type (Warning/Suspend)"); return;};
  
  if (!mysql && !cpu && !memory && !ep && !io) { toastr.error("Select at least one exceeded resource limit"); return; }
 
  if (warning) {text = "WARNING: Resource Abuse on Account '" + user + "' (" + domain + ") - " + server;}
  if (suspend) {text = "IMPORTANT: Account '" + user + "' (" + domain + ") is suspended due to Resource Abuse - " + server;};
  
  text = text + "<br><br>Hello,<br><br>";
  
  text = text + "It has come to our attention that the '" + user + "' hosting account is overusing limits of shared resources, affecting the server performance and all accounts hosted therein. In order to obtain additional information about the limits please refer to Paragraph 10. “Additional Acceptable Use Policy for Virtual accounts” of our AUP at http://www.namecheap.com/legal/hosting/aup.aspx<br><br>";
  
  if ( mysql && !cpu && !memory && !ep && !io ) {
    text = text + "The server is abused by MySQL queries.";
  } else if ( !mysql && (cpu || memory || ep || io) ) {
    text = text + "The following resource limits are being exceeded: ";
    limits = [];
    if (cpu)    { limits.push('CPU usage'); }
    if (memory) { limits.push('Memory Usage'); }
    if (ep)     { limits.push('Entry Processes'); }
    if (io)     { limits.push('Input/Output'); }
    text = text + '<br><br>' + _.map(limits, function(limit) { return "- " + limit; }).join('<br>');
  } else {
    text = text + "The server is abused by MySQL queries and the following resource limits are being exceeded: ";
    limits = [];
    if (cpu)    { limits.push('CPU usage'); }
    if (memory) { limits.push('Memory Usage'); }
    if (ep)     { limits.push('Entry Processes'); }
    if (io)     { limits.push('Input/Output'); }
    text = text + '<br><br>' + _.map(limits, function(limit) { return "- " + limit; }).join('<br>');
  }
  
  text = text + "<br><br>";
  
  text = text + "Unoptimized scripts / incorrectly configured cron jobs / a lot of simultaneous visitors / etc. are probable causes of the resource overuse. ";
  
  advice = [];
  
  if (mysql || cpu || memory | ep) {
    advice.push("- enable caching plugins (Note: Such plugins in conjunction with other website elements might malfunction. That is why in case one of the plugins is already in use it is required to disable the plugin temporary and monitor the account’s activity.)");
  }
  
  if (mysql) {
    advice.push("- revise all active plugins disabling unnecessary ones (in some cases even changing the current theme might be of use)");
    advice.push("- make sure that all websites are well optimized and working as expected (if you are not a developer or professional in website administration, we strongly recommend reaching out to webmaster services)");
    advice.push("- if the SSH access is enabled for the account it is possible to check which threads are being processed by the MySQL server:");
    advice.push("Step 1 - Connect to your database using the following command:");
    advice.push("mysql -uusername -ppassword database_name");
    advice.push("Step 2 - Once connected, please use the following command to see the active threads:");
    advice.push("show full processlist");
  }
  
  if (ep) {
    advice.push("- make sure that RSS is not enabled on your website");
    advice.push("- please refer to the Awstats option in cPanel (in case at least one of your websites is receiving a considerably high amount of hits/incoming traffic volume, an upgrade is the most valid solution)");
    advice.push("- if the SSH access is enabled for the account the “ top -c ” command is of use in order to find the webpages causing the most significant impact (in case an active process takes much time or a critical amount of virtual memory for being completed, it should be disabled)");
  }
  
  // if (io) {
  //   advice.push("- make sure that the CloudFlare service is enabled. Please refer to the following Namecheap KnowledgeBase articles:");
  //   advice.push("+ to enable the CloudFlare cPanel add-on https://www.namecheap.com/support/knowledgebase/article.aspx/1191/2210/how-to-enable-cloudflare-for-your-domain-name");
  //   advice.push("+ to obtain additional information about CloudFlare https://www.namecheap.com/support/knowledgebase/subcategory.aspx?type=category&contentid=2210&categorytitle=cpanel%20addons");
  // }
  
  if (advice.length > 0) {
    text = text + "Here are the diagnostic steps generally suggested for finding the corresponding solution:<br><br>";
    text = text + advice.join('<br>');
  }
  
  text = text + "<br><br>The following Namecheap KnowledgeBase category contains articles about resource limits, LVE (Lightweight Virtual Environment) statistics and measures applicable for resource overuse issues https://www.namecheap.com/support/knowledgebase/subcategory.aspx/103/lve-cloudlinux<br><br>";
  
  text = text + "Additionally, you might consider upgrading your current hosting plan to " + upgrade + ". All upgrades are processed on the prorate basis, thus it will be needed to pay only for the difference between the two plans. The prorated refund for your *current plan* will be carried over to your Namecheap funds, that can be used to settle the next generated invoice or pay for any other services with Namecheap."
  
  if (reseller) { text = text + " If you are using third-party licenses (e.g. cPanel, Softaculous or WHMCS) purchased separately, pleases let us draw your attention that they are non-refundable according to the Acceptable Use Policy." }
  
  text = text + "<br><br>";
  
  if (suspend) { text = text + "Unfortunately, we have been forced to suspend the reported account in order to prevent the resource abuse and its impact on other accounts located on the server. In order to have the account unsuspended it is required to confirm that all measures necessary for the issue resolving will be taken immediately after the unsuspension.<br><br>"; }
  
  if (warning) { text = text + "It is required to look into the issue decreasing the resource usage and providing us with the corresponding results within the next " + time + ". Otherwise, if the resource overuse persists after the time-frame provided and/or no response is received from your side we might be forced to suspend the account in question. We would like to emphasize that in case the impact on the server increases within the specified time-frame there might no other option but to suspend the account immediately, to our regret.<br><br>"; }
  
  text = text + "Looking forward to your reply.<br><br>";
  
  mysqllog = document.getElementById("mysqlLogs").value.replace(/\n/g, '<br>');
  lvelog   = document.getElementById("logs").value.replace(/\n/g, '<br>');
  
  log = [];
  if (mysqllog.length > 0) { log.push(mysqllog); }
  if (lvelog.length > 0)   { log.push(lvelog); }
  
  if (log.length > 0) {
    text = text + "================[ Please find the additional information below / attached. ]================<br><br>";
    text = text + log.join("<br><br>==========================================<br><br>");
  }
  
  text = text + "<br><br>================[ Notations  ]================<br><br>";

  text = text + "ID : LVE Id or username<br>";
  text = text + "aCPU : Average CPU usage<br>";
  text = text + "mCPU : Max CPU usage<br>";
  text = text + "lCPU : CPU Limit<br>";
  text = text + "aEP : Average Entry Processes<br>";
  text = text + "mEP : Max Entry Processes<br>";
  text = text + "lEP : maxEntryProc limit<br>";
  text = text + "aVMem : Average Virtual Memory Usage<br>";
  text = text + "mVMem : Max Virtual Memory Usage<br>";
  text = text + "lVMem : Virtual Memory Limit<br>";
  text = text + "VMemF : Out Of Memory Faults<br>";
  text = text + "EPf : Entry processes faults<br>";
  text = text + "aPMem : Average Physical Memory Usage<br>";
  text = text + "mPMem : Max Physical Memory Usage<br>";
  text = text + "lPMem : Physical Memory Limit<br>";
  text = text + "aNproc : Average Number of processes<br>";
  text = text + "mNproc : Max Number of processes<br>";
  text = text + "lNproc : Limit of Number of processes<br>";
  text = text + "PMemF : Out Of Physical Memory Faults<br>";
  text = text + "NprocF : Number of processes faults<br>";
  text = text + "aIO : Average I/O<br>";
  text = text + "mIO : Max I/O<br>";
  text = text + "lIO : I/O Limit<br>";
  
  text = text + "<br>=========================================="
  
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