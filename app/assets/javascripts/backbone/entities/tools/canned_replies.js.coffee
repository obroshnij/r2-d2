@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  # common

  class Entities.CannedRepliesLeafsCollection extends App.Entities.Collection
    model: (args)->
      if args.type == 'canned_reply'
        return new Entities.CannedReplyReply(args)
      else if args.type == 'canned_category'
        return new Entities.CannedReplyCategory(args)
      else if args.type == 'macros_category'
        return new Entities.CannedReplyMacrosCategory(args)
      else if args.type == 'macros_reply'
        return new Entities.CannedReplyMacrosReply(args)

    urlRoot: (args) ->
      Routes.tools_canned_replies_category_path()

    resourceName: 'Tools::CannedReplies::Category'

  API =

    getCannedCollection: ->
      categories = new Entities.CannedRepliesCategoriesCollection
      categories.fetch()
      categories

    getMacrosCollection: ->
      categories = new Entities.CannedRepliesMacrosCollection
      categories.fetch()
      categories

  App.reqres.setHandler 'tools:canned_replies:canned:entities', ->
    API.getCannedCollection()

  App.reqres.setHandler 'tools:canned_replies:macros:entities', ->
    API.getMacrosCollection()
