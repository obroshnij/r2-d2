@Artoo.module 'LegalHostingAbuseApp.Process', (Process, App, Backbone, Marionette, $, _) ->
  
  class Process.Form extends Marionette.ItemView
    template: 'legal_hosting_abuse/process/form'
    
    modal:
      title: 'Process Hosting Abuse'
              
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