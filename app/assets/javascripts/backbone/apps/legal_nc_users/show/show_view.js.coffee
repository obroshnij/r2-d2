@Artoo.module 'LegalNcUsersApp.Show', (Show, App, Backbone, Marionette, $, _) ->
  
  class Show.Layout extends App.Views.LayoutView
    template: 'legal_nc_users/show/layout'

    regions:
      panelRegion:                    '#panel-region'
      relatedUsersRegion:             '#related-users-region'
      abuseReportsTableRegion:        '#abuse-reports-region'
      relatedAbuseReportsTableRegion: '#related-abuse-reports-region'
      commentsRegion:                 '#comments-region'


  class Show.Panel extends App.Views.ItemView
    template: 'legal_nc_users/show/panel'

    modelEvents:
      'sync change' : 'render'

  class Show.RelatedUsers extends App.Views.ItemView
    template: 'legal_nc_users/show/related_users'

    modelEvents:
      'sync change' : 'render'

    onShow: ->
      relations = @model.get('user_relations')

      if relations

        container = document.getElementById 'user-relations'

        options =
          clickToUse: true,
          edges:
            font:
              align: 'top',
              size: 8
          nodes:
            shape: 'dot'
            color:
              border: '#007095',
              background: '#008CBA',
              highlight:
                border: '#007095',
                background: '#007095'
            font:
              color: '#222222'

        graph =
          nodes: relations.nodes,
          edges: relations.edges

        network = new vis.Network container, graph, options

  class Show.AbuseReports extends App.Views.ItemView
    tagName: 'li'

    template: 'legal_nc_users/show/abuse_report'

  class Show.AbuseReportsTable extends App.Views.CompositeView

    initialize: (options) ->
      @title = options.title

    onShow: (options)->
      this.destroy() unless options.collection.length > 0

    template: 'legal_nc_users/show/table'

    childView:          Show.AbuseReports
    childViewContainer: 'ul'

    serializeData: ->
      data = super
      data.title = @title
      data

  class Show.RelatedAbuseReports extends App.Views.ItemView
    tagName: 'li'

    template: 'legal_nc_users/show/related_abuse_report'

  class Show.RelatedAbuseReportsTable extends App.Views.CompositeView

    initialize: (options) ->
      @title = options.title

    onShow: (options)->
      this.destroy() unless options.collection.length > 0

    template: 'legal_nc_users/show/table'

    childView:          Show.RelatedAbuseReports
    childViewContainer: 'ul'

    serializeData: ->
      data = super
      data.title = @title
      data
