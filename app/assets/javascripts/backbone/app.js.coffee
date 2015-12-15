@Artoo = do (Backbone, Marionette) ->
  
  App = new Marionette.Application
  
  App.on 'before:start', (options) ->
    @environment = options.environment
    @currentUser = App.request 'set:current:user', options.currentUser
  
  App.addRegions
    headerRegion: '#header-region'
    mainRegion:   '#main-region'
    footerRegion: '#footer-region'
    
  App.rootRoute = Routes.new_hosting_abuse_report_path()
  
  App.on 'start', ->
    @addRegions modalRegion: { selector: '#modal-region', regionClass: App.Regions.Modal }
    
    @startHistory()
    @navigate(@rootRoute, trigger: true) unless @getCurrentRoute()
    
    App.module('HeaderApp').start()
    App.module('FooterApp').start()
  
  App.reqres.setHandler 'get:current:user', ->
    App.currentUser
  
  App.reqres.setHandler 'default:region', ->
    App.mainRegion
  
  App