@Artoo.module 'ToolsCannedRepliesMacrosApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.LayoutView
    template: 'tools_canned_replies_macros/list/layout'

    regions:
      contentRegion:  '#canned-replies-content-region'
      searchRegion:   '#canned-replies-search-region'

  class List.ReplyLeaf extends App.Views.CompositeView
    template: 'tools_canned_replies_macros/list/_reply_leaf'
    tagName: 'li'

    modelEvents:
      "change": "render"

    events: ->
      {
        "click .reply-leaf[data-id=#{this.model.get('id')}][data-type='reply']" : 'showContent'
      }

    showContent: (evt) ->
      if @model.get('fetched')
        $(@el).children().first().find('.toggle').toggleClass('expanded-toggle')
        $(@el).children().first().find('.toggle').children('icon').toggleClass('fa-rotate-180')
        $(@el).children().last().find('.reply-content').toggleClass('expanded')
      else
        @model.fetch().then(
          (() ->
            @model.set({ fetched: true });
            $(@el).children().first().find('.toggle').toggleClass('expanded-toggle')
            $(@el).children().first().find('.toggle').children('icon').toggleClass('fa-rotate-180')
            $(@el).children().last().find('.reply-content').toggleClass('expanded')
          ).bind(@);
        )


  class List.TreeLeaf extends App.Views.CompositeView
    template: 'tools_canned_replies_macros/list/_category_leaf'
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
      $(@el).children().first().find('.toggle').toggleClass('expanded-toggle')
      $(@el).children().first().find('.toggle').children('icon').toggleClass('fa-rotate-180')
      $(@el).children().last().toggleClass('expanded')

  class List.TreeRoots extends App.Views.CollectionView
    template: 'tools_canned_replies_macros/list/_roots'

    tagName: 'ul'
    className: 'no-bullet replies-list'

    childView: List.TreeLeaf
    childViewContainer: 'div'

    childViewOptions: (model, index) ->
      return {
        model:      model,
        collection: model.get('nodes')
      }

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
          name:     'content'
          label:    'Text'
        ]
      ]
