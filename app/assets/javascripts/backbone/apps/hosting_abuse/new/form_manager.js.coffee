@Artoo.module 'HostingAbuseApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.FormManager extends App.Components.Form.FieldsController
      
    formFields: ->
      fields = [
        {
          legend: 'Basic info'
          id: 'basic'
          fields: [
            { name: 'first_name', label: 'First Name', hint: 'Your first name' },
            { name: 'last_name',  label: 'Last Name' }
          ]
        }, {
          legend: 'Education',
          id: 'education'
          fields: [
            { name: 'university', label: 'University', hint: 'University you studied at' },
            { name: 'department', label: 'Department' }
          ]
        }
      ]
      
      new App.Entities.FieldsetCollection fields
      
    onInputFirstName: (val) ->
      console.log 'first name', val