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
      new Entities.Navs [
        { divider: true }
        { name: 'Tools',         url: '#/tools',   icon: 'fi-widget'        }
        { divider: true }
        { name: 'Legal & Abuse', url: '#/legal',   icon: 'fi-sheriff-badge' }
        { divider: true }
      ]
      
    getLegalNavs: ->
      new Entities.Navs [
        { name: 'Hosting Abuse', url: '#/legal/hosting_abuse', icon: 'fa fa-fw fa-server' }
      ]
      
    getToolsNavs: ->
      new Entities.Navs [
        { name: 'Whois',               url: '#/tools/whois',  icon: 'fa fa-fw fa-file-o' }
        { name: 'Bulk Whois',          url: '/whois',         icon: 'fa fa-fw fa-files-o' }
        { name: 'Domains Extractor',   url: '/parse_domains', icon: 'fa fa-fw fa-search' }
        { name: 'Lists Compare Tool',  url: '/compare',       icon: 'fa fa-fw fa-list' }
      ]
  
  
  App.reqres.setHandler 'nav:entities', ->
    API.getNavs()
    
  App.reqres.setHandler 'legal:nav:entities', ->
    API.getLegalNavs()
    
  App.reqres.setHandler 'tools:nav:entities', ->
    API.getToolsNavs()