@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  #canned
  class Entities.CannedReplyCategory extends App.Entities.Model
    urlRoot: -> Routes.tools_canned_replies_category_path()

    defaults:
      expanded: false
      index:    0

    resourceName: 'Tools::CannedReplies::Category'

  class Entities.CannedReplyReply extends App.Entities.Model
    urlRoot: -> Routes.tools_canned_replies_canned_replies_path()

    defaults:
      fetched: false
      index:    0

    parse: (resp) ->
      resp.items

    resourceName: 'Tools::CannedReplies::Reply'

  class Entities.CannedRepliesCategoriesCollection extends App.Entities.Collection
    model: Entities.CannedReplyCategory

    url: -> Routes.tools_canned_replies_canned_categories_path()

    parseRecords: (resp) ->
      roots = @_findRoots(resp.items)
      roots.map (r) => return @_findLeafs(resp.items, r)
      roots

    _findRoots: (items) ->
      return _.filter(items, (i) => i['category_id'] == null)

    _findLeafs: (items, node, index=1) ->
      id = node.id
      categoryLeafs = _.filter(items, (i) => i['category_id'] == id && i['type'] == 'canned_category')
      replyLeafs = _.filter(items, (i) => i['category_id'] == id && i['type'] == 'canned_reply')

      leafs = categoryLeafs.concat(replyLeafs)

      node.nodes = new Entities.CannedRepliesLeafsCollection(leafs)
      node.nodes.map (n) => n.set({index: index, expanded: false})
      node.nodes.where({ type: 'canned_category' }).map (n) => return @_findLeafs(items, n, index+1)
      return node

  #macro

  class Entities.CannedReplyMacrosCategory extends App.Entities.Model
    urlRoot: -> Routes.tools_canned_replies_macros_category_path()

    defaults:
      expanded: false
      index:    0

    resourceName: 'Tools::CannedReplies::MacrosCategory'

  class Entities.CannedReplyMacrosReply extends App.Entities.Model
    urlRoot: -> Routes.tools_canned_replies_macros_replies_path()

    defaults:
      fetched: false
      index:    0

    parse: (resp) ->
      resp.items

    resourceName: 'Tools::CannedReplies::MacrosReply'

  class Entities.CannedRepliesMacrosCollection extends Entities.CannedRepliesCategoriesCollection
    model: Entities.CannedReplyMacrosCategory

    url: -> Routes.tools_canned_replies_macros_categories_path()

    parseRecords: (resp) ->
      roots = @_findRoots(resp.items)
      roots.map (r) => return @_findLeafs(resp.items, r)
      roots

    _findRoots: (items) ->
      return _.filter(items, (i) => i['category_id'] == null)

    _findLeafs: (items, node, index=1) ->
      id = node.id
      categoryLeafs = _.filter(items, (i) => i['category_id'] == id && i['type'] == 'macros_category')
      replyLeafs = _.filter(items, (i) => i['category_id'] == id && i['type'] == 'macros_reply')

      leafs = categoryLeafs.concat(replyLeafs)

      node.nodes = new Entities.CannedRepliesLeafsCollection(leafs)
      node.nodes.map (n) => n.set({index: index, expanded: false})
      node.nodes.where({ type: 'macros_category' }).map (n) => return @_findLeafs(items, n, index+1)
      return node

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
