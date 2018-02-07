@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  # class Entities.CannedReplyCategory extends App.Entities.Model
  #   urlRoot: -> Routes.tools_canned_replies_categories_path()
  #
  #   resourceName: 'Tools::CannedReplies::Category'
  #
  # class Entities.CannedRepliesCategoriesCollection extends App.Entities.Collection
  #   model: Entities.CannedReplyCategory
  #
  #   url: -> Routes.tools_canned_replies_categories_path()
  #
  #
  # API =
  #
  #   getCannedRepliesCategoriesCollection: ->
  #     replies = new Entities.CannedRepliesCategoriesCollection
  #     replies.fetch()
  #     replies
  #
  # App.reqres.setHandler 'import:canned_replies:category:entity', ->
  #   new Entities.CannedReplyCategory
  #
  # App.reqres.setHandler 'import:canned_replies:category:entities', ->
  #   API.getCannedRepliesCategoriesCollection()
