@Artoo.module 'UserManagementRolesApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Layout extends App.Views.LayoutView
    template: 'user_management_roles/list/layout'
    
    regions:
      panelRegion:      '#panel-region'
      searchRegion:     '#search-region'
      rolesRegion:      '#roles-region'
      paginationRegion: '#pagination-region'
      
  
  class List.Panel extends App.Views.ItemView
    template: 'user_management_roles/list/panel'
    
    triggers:
      'click a' : 'new:role:clicked'
      
  
  class List.SearchSchema extends Marionette.Object
    
    form:
      buttons:
        primary:   'Search'
        cancel:    false
        placement: 'left'
      syncingType: 'buttons'
      focusFirstInput: false
      search: true
    
    schema: ->
      [
        legend:    'Filters'
        isCompact: true
        
        fields: [
          name:     'name_cont'
          label:    'Name contains'
        ]
      ]
      
  
  class List.RoleView extends App.Views.ItemView
    template: 'user_management_roles/list/_role'
    
    tagName: 'li'
    
    triggers:
      'click .edit-groups'      : 'edit:groups:clicked'
      'click .edit-permissions' : 'edit:permissions:clicked'
      
    modelEvents:
      'change' : 'render'
    
  
  class List.RolesView extends App.Views.CompositeView
    template: 'user_management_roles/list/roles'
    
    childView:          List.RoleView
    childViewContainer: 'ul'
    
    collectionEvents:
      'collection:sync:start' : 'syncStart'
      'collection:sync:stop'  : 'syncStop'
      
    syncStart: ->
      @addOpacityWrapper()
      
    syncStop: ->
      @addOpacityWrapper false
      
    onDestroy: ->
      @addOpacityWrapper false