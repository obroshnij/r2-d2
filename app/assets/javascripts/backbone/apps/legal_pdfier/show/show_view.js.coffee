@Artoo.module 'LegalPdfierApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.LayoutView
    template: 'legal_pdfier/show/layout'

    regions:
      panelRegion:    '#panel-region'
      pagesRegion:    '#pages-region'


  class Show.Panel extends App.Views.ItemView
    template: 'legal_pdfier/show/panel'

    modelEvents:
      'sync change' : 'render'

    triggers:
      'click .toggle-edit-report' : 'toggle:edit:report:clicked'
      'click .merge'              : 'merge:clicked'

    serializeData: ->
      data        = super
      currentUser = App.request 'get:current:user'

      data.checked  = @model.checked
      data.canMerge = @model.canMerge
      data.canEdit  = not @model.get('edited_by') or @model.get('edited_by_id') is currentUser.id
      data


  class Show.Page extends App.Views.ItemView
    template: 'legal_pdfier/show/_page'

    tagName: 'li'

    attributes: ->
      id: @model.id

    modelEvents:
      'change' : 'render'

    triggers:
      'click input[type=checkbox]' : 'checkbox:clicked'
      'click .delete-page'         : 'delete:clicked'


  class Show.Pages extends App.Views.CompositeView
    template: 'legal_pdfier/show/pages'

    childView:          Show.Page
    childViewContainer: 'ul'

    modelEvents:
      'sync change' : 'render'

    onRender: ->
      if @model.pages.length
        @$('ul').sortable
          stop: (event, ui) =>
            @model.set 'order', @$('ul').sortable('toArray'), silent: true
            @model.save()
      else
        @$('ul').replaceWith('<p>Nothing imported yet</p>')

    initialize: ->
      @listenTo @model, 'change', =>
        @collection = @model.pages

    serializeData: ->
      data = super
      data.checkText = if @model.pages.every(checked: true) then 'uncheck all' else 'check all'
      data

    triggers:
      'click .check-all'   : 'check:all'
      'click .uncheck-all' : 'uncheck:all'
