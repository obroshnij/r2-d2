@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.WatchedDomain extends App.Entities.Model
    urlRoot: -> Routes.domains_watched_domains_path()
    
    resourceName: 'Domains::WatchedDomain'
    
  
  class Entities.WatchedDomainsCollection extends App.Entities.Collection
    model: Entities.WatchedDomain
    
    url: -> Routes.domains_watched_domains_path()
    
  
  API =
    
    getWatchedDomainsCollection: ->
      domains = new Entities.WatchedDomainsCollection
      domains.fetch()
      domains
      
    getNewWatchedDomain: ->
      new Entities.WatchedDomain
  
  
  App.reqres.setHandler 'watched:domain:entities', ->
    API.getWatchedDomainsCollection()
    
  App.reqres.setHandler 'new:watched:domain:entity', ->
    API.getNewWatchedDomain()