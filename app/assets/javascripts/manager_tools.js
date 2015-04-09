// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

function sendCanned(link) {
  var body = $(link).prev().val().split('\n').join('%0A').replace(/&/g, "%26");
  var fullName = $(link).closest('div.employee-container').find('h3').text();
  var month = $('div#month').text();
  var subject = "Salary Report %7C " + fullName + " - " + month;
  var link = "mailto:?body=" + body + "&subject=" + subject;
  var cc = $('div#cc').text();
  if (cc.length > 0) link += "&cc=" + cc;
  var bcc = $('div#bcc').text();
  if (bcc.length > 0) link += "&bcc=" + bcc;
  window.open(link, "_self");
}

