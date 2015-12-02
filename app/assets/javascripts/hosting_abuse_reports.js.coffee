@HostingAbuseForm = (selector) ->
  $form      = $(selector)
  
  $service   = $form.find "#service.input select"
  $abuseType = $form.find "#abuse-type.input select"
  
  vpsProhibitedOptions       = ['lve_mysql', 'disc_space', 'cron_jobs']
  dedicatedProhibitedOptions = ['lve_mysql', 'disc_space', 'cron_jobs', 'ddos']
  peProhibitedOptions        = ['lve_mysql', 'disc_space', 'cron_jobs', 'ddos', 'ip_feedback']
  
  visibleFields = null
  
  $service.change ->
    updateAbuseType()
    updateInputRows()
    updateVisibleFields()
    
  updateVisibleFields = ->
    visibleFields = $("#client-details .row.input:visible").find('input, select')
    visibleFields.change ->
      updateAbusePart() if isReady()
      
  isReady = ->
    ready = true
    visibleFields.each (index, item) ->
      ready = false if $(item).val() is ""
    ready
      
  updateAbusePart = ->
    $.get "/hosting_abuse_reports/update_form", visibleFields.serialize()
    
  updateInputRows = ->
    val = $service.val()
    showFormFields ".row[data-service~='#{val}']"
    hideFormFields ".row[data-service]:not([data-service~='#{val}'])"
    
  showFormFields = (selector) ->
    $form.find(selector).each (index, item) -> showFormField(item)
    
  showFormField = (selector) ->
    $(selector).show()
    
  hideFormFields = (selector) ->
    $form.find(selector).each (index, item) -> hideFormField(item)
    
  hideFormField = (selector) ->
    $(selector).hide()
    $(selector).find('select, input').val('')
  
  updateAbuseType = ->
    if $service.val() is "" then disableAbuseType() else enableAbuseType()
    
  disableAbuseType = ->
    $abuseType.attr 'disabled', true
    $abuseType.val('')
    
  enableAbuseType = ->
    $abuseType.attr 'disabled', false
    updateAbuseTypeOptions()
    
  updateAbuseTypeOptions = ->
    enableOptions  "option"
    disableOptions getOptionsSelector(vpsProhibitedOptions)       if $service.val() is 'vps'
    disableOptions getOptionsSelector(dedicatedProhibitedOptions) if $service.val() is 'dedicated'
    disableOptions getOptionsSelector(peProhibitedOptions)        if $service.val() is 'pe'
  
  getOptionsSelector = (array) ->
    _.map array, (val) ->
      "option[value='#{val}']"
    .join ", "
  
  enableOptions = (selector) ->
    $abuseType.find(selector).attr('disabled', false)
  
  disableOptions = (selector) ->
    $abuseType.find(selector).attr('disabled', true)
    
  $service.change()
      
  this
  
  
@HostingAbuseSpam = (selector) ->
  $fieldset = $(selector)
  
  $fieldset.find("#detected_by input[type=checkbox]").change ->
    updateInputFields()
  
  isChecked = (checkbox) ->
    $fieldset.find("#detected_by input[type=checkbox]:checked").map (index, item) ->
      $(item).val()
    .toArray().indexOf(checkbox) > -1
      
  updateInputFields = ->
    if isChecked("other")      then showFormField(".row#other.input")        else hideFormField(".row#other.input")
    if isChecked("complaints") then hideFormField(".row#queue-amount.input") else showFormField(".row#queue-amount.input")
    
  showFormField = (selector) ->
    $(selector).show(200)
    
  hideFormField = (selector) ->
    $(selector).hide(200)
    $(selector).find('select, input').val('')

  this
  

@HostingAbuseCronJob = (selector) ->
  $fieldset = $(selector)
    
  $fieldset.find("#measure input[type=radio]").change ->
    updateOtherField()
  
  otherIsChecked = ->
    $fieldset.find("#measure input[type=radio]:checked").val() is "other"
    
  updateOtherField = ->
    if otherIsChecked() then showOtherField() else hideOtherField()
    
  showOtherField = ->
    $(".row#other").show(200)
    
  hideOtherField = ->
    $(".row#other").hide(200)
    $(".row#other input").val("")
    
  this


$(document).ready ->
  
  new HostingAbuseForm('#new_hosting_abuse_form')