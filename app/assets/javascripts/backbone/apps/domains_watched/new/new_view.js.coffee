@Artoo.module 'DomainsWatchedApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Schema extends Marionette.Object
    
    modal:
      size:  'tiny'
      title: 'New Watched Domain'
    
    schema: ->
      [
        legend:   'New Watched Domain'
        hasHints: false
        
        fields: [
          name:    'name'
          label:   'Name'
        ,
          name:    'comment'
          label:   'Comments'
          tagName: 'textarea'
        ]
      ]