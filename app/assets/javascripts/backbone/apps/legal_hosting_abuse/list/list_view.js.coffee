@Artoo.module 'LegalHostingAbuseApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Layout extends App.Views.LayoutView
    template: 'legal_hosting_abuse/list/layout'
    
    regions:
      panelRegion:   '#panel-region'
      searchRegion:  '#search-region'
      reportsRegion: '#reports-region'
      
  class List.Panel extends App.Views.ItemView
    template: 'legal_hosting_abuse/list/panel'
    
    triggers:
      'click a' : 'submit:report:clicked'
    
  class List.SearchSchema extends Marionette.Object
    
    form:
      buttons:
        primary: 'Search'
        cancel:  false
        placement: 'left'
      syncingType: 'buttons'
      focusFirstInput: false
      search: true
    
    schema: ->
      [
        legend:    'Filters'
        isCompact: true
        
        fields: [
          name:     'service_id'
          label:    'Service'
          tagName:  'select'
          options:  @getServices()
        ,
          name:     'type_id'
          label:    'Abuse Type'
          tagName:  'select'
          options:  @getAbuseTypes()
        ]
      ]
    
    getOptions: (name) ->
      collection = App.request("legal:hosting:abuse:#{name}:entities")
      collection.map (item) ->
        item.attributes
    
    getServices:    -> @getOptions 'service'
    getAbuseTypes:  -> @getOptions 'type'
  
  
  class List.Reports extends App.Views.ItemView
    template: 'legal_hosting_abuse/list/reports'