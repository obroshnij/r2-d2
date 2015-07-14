# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  
  $("#abuse_report_abuse_report_type").change ->
    $.get "/update_abuse_report_form", { abuse_report_type_id: $(this).val() }
    
@toggleAbuseReportRow = (css_selector) ->
  $row = $(css_selector)
  if $row.css('display') == 'none'
    $row.css('display', 'table-row')
  else
    $row.css('display', 'none')