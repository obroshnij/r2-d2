# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  
  abuseReportForm()

@updateAbuseReportFields = (sel) ->
  $.get "/update_abuse_report_form", { abuse_report_type_id: $(sel).val() }
  
@abuseReportForm = ->
  
  $('form').on 'form:validate', ->
    toggleReferenceFields $('.responded-previously-buttons').find('input[type="radio"]:checked')[0]
    toggleFreeDNSFields $('.free-dns-buttons').find('input[type="radio"]:checked')[0]
    validateCfcCommentField $('.cfc-related-inputs').find('input[type="radio"]:checked')[0]

  $('.responded-previously-buttons').find('input[type="radio"]').change ->
    toggleReferenceFields @
  
  $('.free-dns-buttons').find('input[type="radio"]').change ->
    toggleFreeDNSFields @
  
  $('.cfc-related-inputs').find('input[type="radio"]').change ->
    validateCfcCommentField @
  
  $('form').on 'click', '.add-virtus-fields', (event) ->
    time = (new Date).getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(@).closest('form').find('#virtus-fields-container').append $(@).data('fields').replace(regexp, time)
    $('#virtus-fields-container').find('textarea').enableClientSideValidations()
    $('#virtus-fields-container').find('input').enableClientSideValidations()
    event.preventDefault()

  $('form').on 'click', '.remove-virtus-fields', (event) ->
    $(this).closest('.virtus-fields').remove()
    event.preventDefault()

  $('form').submit (event) ->
    checked = true
    $('.relation-type-check-boxes').each (index, element) ->
      checked = false if $(element).find('input[type=\'checkbox\']:checked')[0] == undefined
      
    if checked == false
      event.preventDefault()
      toastr.error 'Please make sure at least one relation type is selected'

@toggleReferenceFields = (radio) ->
  if $(radio).val() == 'false'
    $('.reference-fields').find('input').val('foo').change().focusout().disableClientSideValidations().val('').attr 'disabled', true
  else
    $('.reference-fields').find('input').attr('disabled', false).enableClientSideValidations()

@toggleFreeDNSFields = (radio) ->
  if $(radio).val() == 'FreeDNS'
    $('.free-dns-fields').find('input').attr('disabled', false).enableClientSideValidations()
  else
    $('.free-dns-fields').find('input').val('123').change().focusout().disableClientSideValidations().val('').attr 'disabled', true

@validateCfcCommentField = (radio) ->
  $field = $('.cfc-comment textarea')
  if $(radio).val() == 'false'
    if /^\s*$/.test($field.val())
      $field.val('foo').change().focusout().disableClientSideValidations().val('')
    else
      $field.disableClientSideValidations()
  else
    $field.enableClientSideValidations()
