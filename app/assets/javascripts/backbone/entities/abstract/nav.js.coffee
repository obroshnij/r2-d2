@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Nav extends App.Entities.Model
    
    isDivider: -> @get('divider')
  
  class Entities.Navs extends App.Entities.Collection
    model: Entities.Nav
    
    selectByName: (name) ->
      @select ( @findWhere(name: name) or @first() )
    
    @include 'SelectOne'
  
  
  API =
    
    getNavs: ->
      new Entities.Navs [
        { divider: true }
        { name: 'Tools',         url: '#/tools',   icon: 'fi-widget'        }
        { divider: true }
        { name: 'Legal & Abuse', url: '#/legal',   icon: 'fi-sheriff-badge' }
        { divider: true }
      ]
      
    getLegalNavs: ->
      new Entities.Navs [
        { name: 'Hosting Abuse', url: '#/legal/hosting_abuse/new', icon: 'fa fa-fw fa-server' }
      ]
  
  
  App.reqres.setHandler 'nav:entities', ->
    API.getNavs()
    
  App.reqres.setHandler 'legal:nav:entities', ->
    API.getLegalNavs()