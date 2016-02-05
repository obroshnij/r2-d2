@Artoo.module 'LegalHostingAbuseApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Layout extends App.Views.LayoutView
    template: 'legal_hosting_abuse/list/layout'
    
    regions:
      panelRegion:      '#panel-region'
      searchRegion:     '#search-region'
      reportsRegion:    '#reports-region'
      paginationRegion: '#pagination-region'
      
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
          name:     'service_id_eq'
          label:    'Service'
          tagName:  'select'
          options:  @getServices()
        ,
          name:     'type_id_eq'
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
  
  
  class List.Report extends App.Views.ItemView
    template: 'legal_hosting_abuse/list/_report'
    
    tagName:  'li'
      
    ui:
      'toggle' : 'a.toggle'
      'icon'   : 'a.toggle icon'
      'expand' : '.row.expand'
      
    triggers:
      'click @ui.toggle'      : 'toggle:clicked'
      'click .process-report' : 'process:hosting:abuse:clicked'
      'click .dismiss-report' : 'dismiss:hosting:abuse:clicked'
      'click .edit-report'    : 'edit:hosting:abuse:clicked'
      
    onToggleClicked: ->
      @ui.expand.toggle      200
      @ui.toggle.toggleClass 'expanded'
      @ui.icon.toggleClass   'fa-rotate-180'
  
  
  class List.Reports extends App.Views.CompositeView
    template:  'legal_hosting_abuse/list/reports'
    
    childView:          List.Report
    childViewContainer: 'ul'
    
    className: 'clearfix'
      
    collectionEvents:
      'collection:sync:start' : 'syncStart'
      'collection:sync:stop'  : 'syncStop'
      
    syncStart: ->
      @addOpacityWrapper()
      
    syncStop: ->
      @addOpacityWrapper false
      
    onDestroy: ->
      @addOpacityWrapper false