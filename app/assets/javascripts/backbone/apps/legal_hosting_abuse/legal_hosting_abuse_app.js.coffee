@Artoo.module 'LegalHostingAbuseApp', (LegalHostingAbuseApp, App, Backbone, Marionette, $, _) ->
  
  class LegalHostingAbuseApp.Router extends App.Routers.Base
    
    appRoutes:
      'legal/hosting_abuse'          : 'list'
      'legal/hosting_abuse/new'      : 'newReport'
      'legal/hosting_abuse/:id/edit' : 'edit'
  
  
  API =
    
    list: (region) ->
      return App.execute 'legal:list', 'Hosting Abuse', { action: 'list' } if not region
      
      new LegalHostingAbuseApp.List.Controller
        region: region
    
    newReport: (region) ->
      return App.execute 'legal:list', 'Hosting Abuse', { action: 'newReport' } if not region
      
      new LegalHostingAbuseApp.New.Controller
        region: region
    
    edit: (id, region) ->
      return App.execute 'legal:list', 'Hosting Abuse', { action: 'edit', id: id } if not region
      
      new LegalHostingAbuseApp.New.Controller
        region: region
        id:     id
    
    process: (report) ->
      new LegalHostingAbuseApp.Process.Controller
        region: App.modalRegion
        report: report
    
    dismiss: (report) ->
      new LegalHostingAbuseApp.Dismiss.Controller
        region: App.modalRegion
        report: report
  
  
  App.vent.on 'legal:nav:selected', (nav, options, region) ->
    return if nav isnt 'Hosting Abuse'
    
    action = options?.action
    action ?= 'list'
    
    if action is 'list'
      App.navigate '/legal/hosting_abuse'
      API.list region
      
    if action is 'newReport'
      App.navigate '/legal/hosting_abuse/new'
      API.newReport region
      
    if action is 'edit'
      App.navigate "/legal/hosting_abuse/#{options.id}/edit"
      API.edit options.id, region
    
  App.vent.on 'submit:report:clicked', ->
    API.newReport()
    
  App.vent.on 'new:report:cancelled', ->
    API.list()
    
  App.vent.on 'hosting:abuse:created', (report) ->
    API.list()
    
  App.vent.on 'edit:hosting:abuse:clicked', (report) ->
    API.edit report.id
    
  App.vent.on 'process:hosting:abuse:clicked', (report) ->
    API.process report
    
  App.vent.on 'dismiss:hosting:abuse:clicked', (report) ->
    API.dismiss report
  
  LegalHostingAbuseApp.on 'start', ->
    new LegalHostingAbuseApp.Router
      controller: API
      resource:   'Legal::HostingAbuse'