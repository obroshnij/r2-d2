@Artoo.module 'LegalNcUsersApp.Show', (Show, App, Backbone, Marionette, $, _) ->
  
  class Show.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      ncUser = App.request 'nc:users:entity', options.id
      @layout = @getLayoutView()
      @listenTo @layout, 'show', =>
        @panelRegion ncUser
        @relatedUsersRegion ncUser
        @abuseReportsTableRegion ncUser
        @relatedAbuseReportsTableRegion ncUser

      @show @layout

    panelRegion: (ncUser) ->
      panelView = @getPanelView ncUser

      App.execute 'when:synced', ncUser, =>
        @show panelView, region: @layout.panelRegion

    relatedUsersRegion: (ncUser) ->
      relatedUsersView = @getRelatedUsersView ncUser

      App.execute 'when:synced', ncUser, =>
        @show relatedUsersView, region: @layout.relatedUsersRegion

    abuseReportsTableRegion: (ncUser) ->
      abuseReportsTableView = @getAbuseReportsTableView ncUser.abuseReports

      @listenTo abuseReportsTableView, 'childview:show:detailed:clicked', (child, args) ->
        App.vent.trigger 'show:detailed:nc:users:clicked', args.model

      App.execute 'when:synced', ncUser, =>
        @show abuseReportsTableView, region: @layout.abuseReportsTableRegion

    relatedAbuseReportsTableRegion: (ncUser) ->
      relatedAbuseReportsTableView = @getRelatedAbuseReportsTableView ncUser.abuseReportsIndirect

      App.execute 'when:synced', ncUser, =>
        @show relatedAbuseReportsTableView, region: @layout.relatedAbuseReportsTableRegion

    getPanelView: (ncUser) ->
      new Show.Panel
        model: ncUser

    getRelatedUsersView: (ncUser) ->
      new Show.RelatedUsers
        model: ncUser

    getAbuseReportsTableView: (reports) ->
      new Show.AbuseReportsTable
        collection: reports
        title: 'Abuse Reports'

    getRelatedAbuseReportsTableView: (reports) ->
      new Show.RelatedAbuseReportsTable
        collection: reports
        title: 'Related Abuse Reports'
      
    getLayoutView: ->
      new Show.Layout