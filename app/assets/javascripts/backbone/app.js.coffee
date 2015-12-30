@Artoo = do (Backbone, Marionette) ->
  
  App = new Marionette.Application
  
  App.on 'before:start', (options) ->
    @bootstrap options
    
    @navs = App.request 'nav:entities'
  
  App.addRegions
    headerRegion: '#header-region'
    mainRegion:   '#main-region'
    footerRegion: '#footer-region'
    
  App.rootRoute = Routes.new_hosting_abuse_report_path()
  
  App.on 'start', ->
    App.module('HeaderApp').start App.navs
    App.module('FooterApp').start()
    
    @addRegions modalRegion: { selector: '#modal-region', regionClass: App.Regions.Modal }
    
    @startHistory()
    @navigate(@rootRoute, trigger: true) unless @getCurrentRoute()
    
  App.vent.on           'nav:select',  (nav) -> App.navs.selectByName nav
  
  App.reqres.setHandler 'get:current:user',  -> App.currentUser
  App.reqres.setHandler 'default:region',    -> App.mainRegion
  App.reqres.setHandler 'concern', (concern) -> App.Concerns[concern]
  
  App