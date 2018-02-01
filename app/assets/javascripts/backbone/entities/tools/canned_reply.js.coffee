@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.CannedReply extends App.Entities.Model
    urlRoot: -> ''

    resourceName: ''

  class Entities.CannedRepliesImport extends App.Entities.Model
    urlRoot: -> ''

    resourceName: ''


  class Entities.CannedRepliesCollection extends App.Entities.Collection
    model: Entities.CannedReply

    url: -> ''


  API =

    getCannedRepliesCollection: ->
      replies = new Entities.CannedRepliesCollection
      replies.fetch()
      replies

  App.reqres.setHandler 'import:canned_replies:entity', ->
    new Entities.CannedRepliesImport
