# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
    
@updateAbuseReportFields = (sel) ->
  $.get "/update_abuse_report_form", { abuse_report_type_id: $(sel).val() }