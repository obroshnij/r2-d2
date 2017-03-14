@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.NcUser extends App.Entities.Model
    urlRoot: -> Routes.legal_nc_users_path()

    initialize: ->
      @abuseReports = new Entities.AbuseReports
      @abuseReportsIndirect = new Entities.AbuseReports
      @listenTo @, 'change:abuse_reports_direct', => @abuseReports.reset @get('abuse_reports_direct')
      @listenTo @, 'change:abuse_reports_indirect', => @abuseReportsIndirect.reset @get('abuse_reports_indirect')

    mutators:

     statusIconsClasses: ->

       statuses = {}
       @get('status_names').map (name) ->
         return statuses[name] = 'fa fa-user-secret action' if name == "Internal Spammer"
         return statuses[name] = 'fi-link action'           if name == "Spammer Related"
         return statuses[name] = 'fi-skull action'          if name == "DNS DDoSer"
         return statuses[name] = 'fa fa-link action'        if name == "DDoSer Related"
         return statuses[name] = 'fi-mail action'           if name == "PE Abuser"
         return statuses[name] = 'fa fa-fire action'        if name == "Has Abuse Notes"
         return statuses[name] = 'fi-crown action'          if name == "Has VIP Domains"
         return statuses[name] = 'fa fa-home action'        if name == "Internal Account"
         return statuses[name] = 'fa fa-diamond action'     if name == "VIP"
       statuses

    resourceName: 'Legal::NcUser'

  class Entities.NcUsersCollection extends App.Entities.Collection
    model: Entities.NcUser

    url: -> Routes.legal_nc_users_path()


  class Entities.AbuseReport extends  App.Entities.Model

  class Entities.AbuseReports extends App.Entities.Collection
    model: Entities.AbuseReport

  API =

    newNcUser: (attrs) ->
      new Entities.NcUser attrs

    newNcUsersCollection: ->
      requests = new Entities.NcUsersCollection
      requests.fetch()
      requests

    getNcUser: (id) ->
      request = new Entities.NcUser id: id
      request.fetch()
      request

  App.reqres.setHandler 'new:legal:nc:user', (attrs = {}) ->
    API.newNcUser attrs

  App.reqres.setHandler 'list:nc:users:entities', ->
    API.newNcUsersCollection()

  App.reqres.setHandler 'nc:users:entity', (id) ->
    API.getNcUser id
