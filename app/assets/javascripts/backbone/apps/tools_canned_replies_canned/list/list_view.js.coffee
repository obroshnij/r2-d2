@Artoo.module 'ToolsCannedRepliesCannedApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.LayoutView
    template: 'tools_canned_replies_canned/list/layout'

    regions:
      contentRegion:  '#canned-replies-content-region'

  class List.ReplyLeaf extends App.Views.CompositeView
    template: 'tools_canned_replies_canned/list/_reply_leaf'
    tagName: 'li'

    modelEvents:
      "change": "render"

    events: ->
      {
        "click .reply-leaf[data-id=#{this.model.get('id')}][data-type='reply']"         : 'showContent'
      }

    showContent: (evt) ->
      window.model = this.model
      # $(this.el).children().last().toggleClass('expanded')
      if @model.get('fetched')
        $(this.el).children().last().toggleClass('expanded')
      else
        @model.fetch().then(
          (() ->
            @model.set({ fetched: true });
            $(this.el).children().last().toggleClass('expanded')).bind(this);
        )


  class List.TreeLeaf extends App.Views.CompositeView
    template: 'tools_canned_replies_canned/list/_category_leaf'
    tagName: 'li'

    childView: (args)->
      if args.model.get('type') == 'category'
        return new List.TreeLeaf(args)
      else
        return new List.ReplyLeaf(args)

    childViewContainer: 'ul'

    events: ->
      {
        "click .leaf[data-id=#{this.model.get('id')}][data-type='category']"      : 'expand'
      }

    childViewOptions: (model, index) ->
      return {
        model:      model,
        collection: model.nodes
      }

    expand: (evt)->
      $(this.el).children().last().toggleClass('expanded')

  class List.TreeRoots extends App.Views.CollectionView
    template: 'tools_canned_replies_canned/list/_roots'

    tagName: 'ul'
    className: 'no-bullet replies-list'

    childView: List.TreeLeaf
    childViewContainer: 'div'

    childViewOptions: (model, index) ->
      return {
        model:      model,
        collection: model.get('nodes')
      }
