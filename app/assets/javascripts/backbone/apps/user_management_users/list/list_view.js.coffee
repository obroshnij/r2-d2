@Artoo.module 'UserManagementUsersApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Layout extends App.Views.LayoutView
    template: 'user_management_users/list/layout'
    
    regions:
      panelRegion:      '#panel-region'
      searchRegion:     '#search-region'
      usersRegion:      '#users-region'
      paginationRegion: '#pagination-region'
      
  
  class List.Panel extends App.Views.ItemView
    template: 'user_management_users/list/panel'
    
    
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
        ,
          name:     'email_cont'
          label:    'Email contains'
        ,
          name:     'groups_name_cont'
          label:    'NC Directory Group Name contains'
        ]
      ]
  
  
  class List.UserView extends App.Views.ItemView
    template: 'user_management_users/list/_user'
    
    tagName: 'li'
    
    triggers:
      'click .edit-role' : 'edit:role:clicked'
      
    modelEvents:
      'change' : 'render'
  
  
  class List.UsersView extends App.Views.CompositeView
    template: 'user_management_users/list/users'
    
    childView:          List.UserView
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