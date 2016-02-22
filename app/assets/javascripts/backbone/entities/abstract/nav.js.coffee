@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Nav extends App.Entities.Model
    
    isDivider: -> @get('divider')
    
    isExternal: ->
      s.startsWith @get('url'), '/'
  
  class Entities.Navs extends App.Entities.Collection
    model: Entities.Nav
    
    selectByName: (name) ->
      @select ( @findWhere(name: name) or @first() )
    
    @include 'SelectOne'
  
  
  API =
    
    getNavs: ->
      new Entities.Navs App.entities.navs.main_navs
      
    getLegalNavs: ->
      new Entities.Navs App.entities.navs.legal_navs
      
    getToolsNavs: ->
      new Entities.Navs App.entities.navs.tools_navs
      
    getUserManagementNavs: ->
      new Entities.Navs App.entities.navs.user_management_navs
  
  
  App.reqres.setHandler 'nav:entities', ->
    API.getNavs()
    
  App.reqres.setHandler 'legal:nav:entities', ->
    API.getLegalNavs()
    
  App.reqres.setHandler 'tools:nav:entities', ->
    API.getToolsNavs()
    
  App.reqres.setHandler 'user:management:nav:entities', ->
    API.getUserManagementNavs()