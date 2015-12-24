@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Nav extends App.Entities.Model
    
    
  class Entities.Navs extends App.Entities.Collection
    model: Entities.Nav
    
  API =
    
    getNavs: ->
      new Entities.Navs [
        { name: 'Tools',         url: '#/tools', icon: 'fi-wrench' }
        { name: 'Legal & Abuse', url: '#/legal', icon: 'fi-sheriff-badge' }
      ]
    
  App.reqres.setHandler 'nav:entities', ->
    API.getNavs()