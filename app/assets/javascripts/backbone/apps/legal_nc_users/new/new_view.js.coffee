@Artoo.module 'LegalNcUsersApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Schema extends Marionette.Object
    
    modal:
      size:  'tiny'
      title: 'New Namecheap User'
      
    schema: ->
      [
        legend:   'New Namecheap User'
        hasHints: false

        fields: [
          name:    'username'
          label:   'Username'
          tagName: 'input'
        ,
          name:    'new_status'
          label:   'Status'
          tagName: 'select'
          options: @getStatuses()
        ,
          name:    'signed_up_on_string'
          label:   'Signup date'
          type:    'date_range_picker'
          dateRangePickerOptions:
            singleDatePicker: true
        ]
      ]
      
    getStatuses: ->
      App.entities.nc_users_statuses