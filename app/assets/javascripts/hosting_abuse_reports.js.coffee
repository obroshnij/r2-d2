@HostingAbuseForm = (selector) ->
  $form      = $(selector)
  
  $service   = $form.find "#service.input select"
  $abuseType = $form.find "#abuse-type.input select"
  
  vpsProhibitedOptions       = ['lve_mysql', 'disc_space', 'cron_job']
  dedicatedProhibitedOptions = ['lve_mysql', 'disc_space', 'cron_job', 'ddos']
  peProhibitedOptions        = ['lve_mysql', 'disc_space', 'cron_job', 'ddos', 'ip_feedback']
  
  $service.change ->
    updateAbuseType()
    updateInputRows()
    updateAbusePart()
  
  $abuseType.change ->
    updateAbusePart()
  
  updateAbusePart = ->
    if isReady()
      $.get "/hosting_abuse_reports/update_form", $form.find("#client-details").serialize()
    else
      $("#dynamic-part").hide 200, ->
        $("#dynamic-part").html('')
      
  isReady = ->
    $service.val().length > 0 && $abuseType.val().length > 0
    
  updateInputRows = ->
    val = $service.val()
    showFormFields ".row[data-service~='#{val}']"
    hideFormFields ".row[data-service]:not([data-service~='#{val}'])"
    
  showFormFields = (selector) ->
    $form.find(selector).each (index, item) -> showFormField(item)
    
  showFormField = (selector) ->
    $(selector).show 200, ->
      $(selector).find('select, input').enableClientSideValidations()
    
  hideFormFields = (selector) ->
    $form.find(selector).each (index, item) -> hideFormField(item)
    
  hideFormField = (selector) ->
    $(selector).hide 200, ->
      disableValidation $(selector).find('select, input')
    
  disableValidation = ($el) ->
    tagName = $el.get(0).tagName
    disableValidationForInput($el)  if tagName is 'INPUT'
    disableValidationForSelect($el) if tagName is 'SELECT'
    
  disableValidationForInput = ($el) ->
    $el.val('123').change().focusout().disableClientSideValidations().val('')
    
  disableValidationForSelect = ($el) ->
    val = $el.find("option[value!='']").first().attr('value')
    $el.val(val).change().focusout().disableClientSideValidations().val('')
  
  updateAbuseType = ->
    if $service.val() is "" then disableAbuseType() else enableAbuseType()
    
  disableAbuseType = ->
    $abuseType.attr 'disabled', true
    $abuseType.val('')
    
  enableAbuseType = ->
    $abuseType.attr 'disabled', false
    updateAbuseTypeOptions()
    $abuseType.val('')
    $abuseType.enableClientSideValidations()
    
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
  
  # Validation
  $form.submit (event) ->
    
    if resourceTypesRendered() and resourceTypesBlank()
      event.preventDefault()
      toastr.error "Resource Types can't be blank"
      
    if detectionMethodsRendered() and detectionMethodsBlank()
      event.preventDefault()
      toastr.error "Detected by can't be blank"
      
  resourceTypesRendered = ->
    !_.isUndefined $form.find("#abuse-part-lve-mysql #resource-types")[0]
  
  resourceTypesBlank = ->
    $form.find("#abuse-part-lve-mysql #resource-types input[type=checkbox]:checked").length is 0
    
  detectionMethodsRendered = ->
    !_.isUndefined $form.find("#abuse-part-spam #detected_by")[0]
    
  detectionMethodsBlank = ->
    $form.find("#abuse-part-spam #detected_by input[type=checkbox]:checked").length is 0
    
  updateAbuseType()
  updateInputRows()
  
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
    $(selector).show 200, ->
      $(selector).find('select, input').enableClientSideValidations()
    
  hideFormField = (selector) ->
    $(selector).hide 200, ->
      disableValidation $(selector).find('select, input')
    
  disableValidation = ($el) ->
    tagName = $el.get(0).tagName
    disableValidationForInput($el)  if tagName is 'INPUT'
    disableValidationForSelect($el) if tagName is 'SELECT'
    
  disableValidationForInput = ($el) ->
    $el.val('123').change().focusout().disableClientSideValidations().val('')
    
  disableValidationForSelect = ($el) ->
    val = $el.find("option[value!='']").first().attr('value')
    $el.val(val).change().focusout().disableClientSideValidations().val('')

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
    $(".row#other").show 200, ->
      $(".row#other input").enableClientSideValidations()
    
  hideOtherField = ->
    $(".row#other").hide 200, ->
      $(".row#other input").val('123').change().focusout().disableClientSideValidations().val('')
    
  this
    

$(document).ready ->
  
  new HostingAbuseForm('#new_hosting_abuse_form')