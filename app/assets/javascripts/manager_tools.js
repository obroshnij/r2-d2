// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

function sendCanned(link) {
  var body = $(link).prev().text().split('\n').join('%0A');
  var fullName = $(link).closest('div.employee-container').find('h3').text();
  var month = $('div#month').text();
  var subject = "Salary Report %7C " + fullName + " - " + month;
  var cc = $('div#cc').text();
  window.open("mailto:?body=" + body + "&subject=" + subject + "&cc=" + cc, "_self");
}