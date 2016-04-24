@Artoo.module 'LegalHostingAbuseApp.Process', (Process, App, Backbone, Marionette, $, _) ->
  
  class Process.Form extends Marionette.ItemView
    template: 'legal_hosting_abuse/process/form'
    
    modal:
      title: 'Process Hosting Abuse'
      
    initialize: (options) ->
      @decisionId = @model.get('decision_id')
      @serviceId  = @model.get('service_id')
              
    onAttach: ->
      if @$('#nc_user_signup').size() > 0
        
        @$('#nc_user_signup').daterangepicker
          autoUpdateInput:  false
          singleDatePicker: true
          showDropdowns:    true
          locale:
            format:      'DD MMMM YYYY'
            firstDay:    1
      
        @$('#nc_user_signup').on 'apply.daterangepicker',  (event, picker) ->
          date = picker.startDate.format('DD MMMM YYYY')
          $(@).val(date).change()
        
    onDestroy: ->
      if @$('#nc_user_signup').size() > 0
        
        @$('#nc_user_signup').off()
        @$('#nc_user_signup').data('daterangepicker').remove()
        
    serializeData: ->
      data = super
      data.decisions = App.entities.legal.hosting_abuse.suggestion
      data
      
    ui:
      ipIsBlacklistedRadio: 'input[name=ip_is_blacklisted]'
      blacklistedIpsField:  '.row.form-field#blacklisted-ips'
      decisionIdSelect:     '#decision_id'
      disregardReasonField: '#disregard-reason'
      
    events:
      'change @ui.ipIsBlacklistedRadio' : 'toggleBlacklistedIpsField'
      'change @ui.decisionIdSelect'     : 'toggleDisregardReasonField'
      
    toggleBlacklistedIpsField: (event) ->
      val = @ui.ipIsBlacklistedRadio.filter(':checked').val()
      if val is 'true' or _.includes([3, 4], @serviceId)
        @ui.blacklistedIpsField.show 200
      else
        @ui.blacklistedIpsField.hide 200
        
    toggleDisregardReasonField: (event) ->
      if @decisionId.toString() isnt @ui.decisionIdSelect.val()
        @ui.disregardReasonField.show 200
      else
        @ui.disregardReasonField.hide 200