@Artoo.module 'LegalHostingAbuseApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.LayoutView
    template: 'legal_hosting_abuse/list/layout'

    regions:
      panelRegion:      '#panel-region'
      searchRegion:     '#search-region'
      reportsRegion:    '#reports-region'
      paginationRegion: '#pagination-region'

  class List.Panel extends App.Views.ItemView
    template: 'legal_hosting_abuse/list/panel'

    triggers:
      'click a' : 'submit:report:clicked'

    serializeData: ->
      canCreate: App.ability.can 'create', 'Legal::HostingAbuse'

  class List.SearchSchema extends Marionette.Object

    form:
      buttons:
        primary:   'Search'
        cancel:    false
        placement: 'left'
      syncingType: 'buttons'
      focusFirstInput: false
      search: true

    schema: ->
      [
        legend:    'Filters'
        isCompact: true

        fields: [
          name:     'service_id_eq'
          label:    'Service'
          tagName:  'select'
          options:  @getServices()
        ,
          name:     'type_id_eq'
          label:    'Abuse Type'
          tagName:  'select'
          options:  @getAbuseTypes()
        ,
          name:     'reported_by_id_eq'
          label:    'Reported by'
          tagName:  'select'
          options:  @getReportedBy()
        ,
          name:     'logs_user_id_eq'
          label:    'Processed by'
          tagName:  'select'
          options:  @getProcessedBy()
        ,
          name:     'server_name_or_efwd_server_name_cont'
          label:    'Server Name contains'
        ,
          name:     'username_or_resold_username_or_nc_user_username_cont'
          label:    'Username contains'
        ,
          name:     'created_at_datetime_between'
          label:    'Reported on'
          type:     'date_range_picker'
        ,
          name:     'ticket_identifier_cont'
          label:    'Ticket ID contains'
        ,
          name:     'status_in'
          label:    'Status'
          tagName:  'select'
          type:     'select2_multi'
          options:  [
            id: 0, name: 'New'
          ,
            id: 3, name: 'Edited'
          ,
            id: 2, name: 'Dismissed'
          ,
            id: 1, name: 'Processed'
          ]
        ,
          name:     'resource_type_id_in'
          label:    'Resource Type'
          tagName:  'select'
          options:  @getResourceTypes()
          dependencies:
            type_id_eq: value: 2
          callback: (fieldValues) ->
            @trigger('unselect:current') if fieldValues.type_id_eq?.toString() isnt '2'
        ]
      ]

    getOptions: (name) ->
      collection = App.request("legal:hosting:abuse:#{name}:entities")
      collection.map (item) ->
        item.attributes

    getServices:      -> @getOptions 'service'
    getAbuseTypes:    -> @getOptions 'type'
    getReportedBy:    -> App.entities.legal.hosting_abuse.reported_by
    getProcessedBy:   -> App.entities.legal.hosting_abuse.processed_by
    getResourceTypes: -> App.entities.legal.hosting_abuse.resource.type


  class List.ReportHeader extends App.Views.ItemView
    template: 'legal_hosting_abuse/list/_header'

    triggers:
      'click .process-report'   : 'process:clicked'
      'click .dismiss-report'   : 'dismiss:clicked'
      'click .edit-report'      : 'edit:clicked'
      'click .unprocess-report' : 'unprocess:clicked'

    events:
      'click .service-link'     : 'followLink'
      'click .dropdown-pane'    : 'doNothing'

    modelEvents:
      'change' : 'render'

    followLink: (event) ->
      event.preventDefault()
      event.stopPropagation()
      window.open event.target.href, target: '_blank'

    doNothing: (event) ->
      event.preventDefault()
      event.stopPropagation()

    serializeData: ->
      data = super
      data.canProcess   = App.ability.can 'mark_processed',   @model
      data.canDismiss   = App.ability.can 'mark_dismissed',   @model
      data.canUnprocess = App.ability.can 'mark_unprocessed', @model
      data.canEdit      = App.ability.can 'update',           @model
      data

    @include 'HasDropdowns'


  class List.ReportClientInfo extends App.Views.ItemView

    getTemplate: ->
      return 'legal_hosting_abuse/list/_client_info_shared'         if @model.get('service_id') is 1
      return 'legal_hosting_abuse/list/_client_info_reseller'       if @model.get('service_id') is 2
      return 'legal_hosting_abuse/list/_client_info_vps'            if @model.get('service_id') is 3
      return 'legal_hosting_abuse/list/_client_info_dedicated'      if @model.get('service_id') is 4
      return 'legal_hosting_abuse/list/_client_info_pe'             if @model.get('service_id') is 5 and @model.get('status') is '_processed'
      return 'legal_hosting_abuse/list/_client_info_eforwarding'    if @model.get('service_id') is 6
      false

    modelEvents:
      'change' : 'render'


  class List.ReportAbuseInfo extends App.Views.ItemView

    getTemplate: ->
      return 'legal_hosting_abuse/list/_abuse_info_pe_spam_queue'    if @model.get('type_id') is 1 and @model.get('service_id') is 5 and @model.get('pe_spam').detection_method_id is 1
      return 'legal_hosting_abuse/list/_abuse_info_pe_spam_feedback' if @model.get('type_id') is 1 and @model.get('service_id') is 5 and @model.get('pe_spam').detection_method_id is 2
      return 'legal_hosting_abuse/list/_abuse_info_pe_spam_other'    if @model.get('type_id') is 1 and @model.get('service_id') is 5 and @model.get('pe_spam').detection_method_id is 3
      return 'legal_hosting_abuse/list/_abuse_info_spam_queue'       if @model.get('type_id') is 1 and @model.get('spam').detection_method_id is 1
      return 'legal_hosting_abuse/list/_abuse_info_spam_feedback'    if @model.get('type_id') is 1 and @model.get('spam').detection_method_id is 2
      return 'legal_hosting_abuse/list/_abuse_info_spam_other'       if @model.get('type_id') is 1 and @model.get('spam').detection_method_id is 3
      return 'legal_hosting_abuse/list/_abuse_info_resource_disc'    if @model.get('type_id') is 2 and @model.get('resource').type_id is 1
      return 'legal_hosting_abuse/list/_abuse_info_resource_lve'     if @model.get('type_id') is 2 and @model.get('resource').type_id is 2
      return 'legal_hosting_abuse/list/_abuse_info_resource_cron'    if @model.get('type_id') is 2 and @model.get('resource').type_id is 3
      return 'legal_hosting_abuse/list/_abuse_info_ddos'             if @model.get('type_id') is 3
      return 'legal_hosting_abuse/list/_abuse_info_other'            if @model.get('type_id') is 4

    modelEvents:
      'change' : 'render'

    @include 'HasDropdowns'
    @include 'HasEditableFields'


  class List.ReportConclusion extends App.Views.ItemView
    template: 'legal_hosting_abuse/list/_conclusion'

    modelEvents:
      'change' : 'render'

    @include 'HasDropdowns'
    @include 'HasEditableFields'


  class List.Report extends App.Views.LayoutView
    template: 'legal_hosting_abuse/list/report'

    regions:
      'headerRegion'     : '.header'
      'clientInfoRegion' : '.client-info'
      'abuseInfoRegion'  : '.abuse-info'
      'conclusionRegion' : '.conclusion'

    triggers:
      'click .header'    : 'toggle:clicked'

    tagName:  'li'

    onShow: ->
      headerView = new List.ReportHeader model: @model
      @headerRegion.show headerView

      clientInfoView = new List.ReportClientInfo model: @model
      @clientInfoRegion.show clientInfoView

      abuseInfoView = new List.ReportAbuseInfo model: @model
      @abuseInfoRegion.show abuseInfoView

      conclusionView = new List.ReportConclusion model: @model
      @conclusionRegion.show conclusionView

    onToggleClicked: ->
      @$el.toggleClass 'expanded'
      @$('.expand').toggle 200

      @$('.header a.toggle').toggleClass      'expanded'
      @$('.header a.toggle icon').toggleClass 'fa-rotate-180'

    onChildviewProcessClicked: (child, options) ->
      @trigger 'process:hosting:abuse:clicked', options

    onChildviewDismissClicked: (child, options) ->
      @trigger 'dismiss:hosting:abuse:clicked', options

    onChildviewEditClicked: (child, options) ->
      @trigger 'edit:hosting:abuse:clicked', options

    onChildviewUnprocessClicked: (child, options) ->
      @trigger 'unprocess:hosting:abuse:clicked', options


  class List.Reports extends App.Views.CompositeView
    template:  'legal_hosting_abuse/list/reports'

    childView:          List.Report
    childViewContainer: 'ul'

    className: 'clearfix'

    collectionEvents:
      'collection:sync:start' : 'syncStart'
      'collection:sync:stop'  : 'syncStop'

    syncStart: ->
      @addOpacityWrapper()

    syncStop: ->
      @addOpacityWrapper false

    onDestroy: ->
      @addOpacityWrapper false
