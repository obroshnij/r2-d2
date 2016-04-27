@Artoo.module 'ToolsEmailVerifierApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Layout extends App.Views.LayoutView
    template: 'tools_email_verifier/new/layout'
    
    regions:
      formRegion:   '#form-region'
      resultRegion: '#result-region'
      
      
  class New.FormSchema extends Marionette.Object
    
    form:
      buttons:
        primary: 'Submit'
        cancel:  false
      syncingType: 'buttons'
    
    schema:
      [
        {
          legend: 'Verify email'
          fields: [
            name:     'query'
            label:    'Email Addresses'
            tagName:  'textarea'
          ]
        }
      ]
      
    
  class New.Result extends App.Views.ItemView
    template: 'tools_email_verifier/new/result'
    
    events:
      'click a[data-email]' : 'showSmtpSession'
      
    showSmtpSession: (event) ->
      event.preventDefault()
      @trigger 'show:smtp:session', $(event.target).attr('data-email')