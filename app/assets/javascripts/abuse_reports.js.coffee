# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  
  $('form').on 'click', '.add-virtus-fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).closest('form').find('#virtus-fields-container').append $(this).data('fields').replace(regexp, time)
    event.preventDefault()
    
  $('form').on 'click', '.remove-virtus-fields', (event) ->
    $(this).closest('.virtus-fields').find('input[type=hidden]').val('1')
    $(this).closest('.virtus-fields').hide()
    event.preventDefault()
    
@updateAbuseReportFields = (sel) ->
  $.get "/update_abuse_report_form", { abuse_report_type_id: $(sel).val() }