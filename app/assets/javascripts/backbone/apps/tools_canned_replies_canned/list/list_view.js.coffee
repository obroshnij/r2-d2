@Artoo.module 'ToolsCannedRepliesCannedApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.LayoutView
    template: 'tools_canned_replies_canned/list/layout'

    regions:
      contentRegion:  '#canned-replies-content-region'
      searchRegion:   '#canned-replies-search-region'

  class List.ReplyLeaf extends App.Views.CompositeView
    template: 'tools_canned_replies_canned/list/_reply_leaf'
    tagName: 'li'
    className: 'item-holder'

    modelEvents:
      "change": "render"

    events: ->
      {
        "click .reply-leaf[data-id=#{this.model.get('id')}][data-type='canned_reply']" : 'showContent',
        "click @ui.copy" : "copyContent"
      }

    ui: ->
      {
        copy:     ".copy-button",
      }

    copyContent: (evt) ->
      temp = document.createElement('textarea');
      temp.type = 'text'
      temp.value = this.model.get('content');
      document.body.append(temp);
      temp.select();
      document.execCommand("copy");
      temp.remove();

    showContent: (evt) ->
      @model.set({expanded: !@model.get('expanded')});
      if !@model.get('fetched')
        @model.fetch().then(
          (() ->
            @model.set({ fetched: true });
          ).bind(@);
        )


  class List.TreeLeaf extends App.Views.CompositeView
    template: 'tools_canned_replies_canned/list/_category_leaf'
    tagName: 'li'

    className: 'category-holder'

    childView: (args)->
      if args.model.get('type') == 'canned_category'
        if (args.model.get('expanded') == true)
          return new List.TreeLeaf(args)
        else
          return new List.TreeLeaf({model: args.model, collection: new args.model.nodes.constructor})
      else
        return new List.ReplyLeaf(args)

    childViewContainer: 'ul'

    modelEvents:
      "change": "render"

    collectionEvents:
      "change": "render"

    events: ->
      {
        "click .leaf[data-id=#{this.model.get('id')}][data-type='canned_category']"      : 'expand'
      }

    childViewOptions: (model, index) ->
      return {
        model:      model,
        collection: model.nodes
      }

    expand: (evt)->
      @model.set({expanded: !@model.get('expanded')});

  class List.TreeRoots extends App.Views.CollectionView
    template: 'tools_canned_replies_canned/list/_roots'

    tagName: 'ul'
    className: 'no-bullet replies-list'

    childViewContainer: 'div'

    collectionEvents:
      "change": "render"

    childView: (args) ->
      if (args.model.get('expanded') == true)
        return new List.TreeLeaf(args)
      else
        return new List.TreeLeaf({model: args.model})

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
          name:     'name_or_content_cont'
          label:    'Name or Content'
        ]
      ]
