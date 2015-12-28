@Artoo.module "Concerns", (Concerns, App, Backbone, Marionette, $, _) ->
  
  Concerns.Selectable =
    
    modelEvents:
      'selected'   : 'changeSelected'
      'deselected' : 'changeSelected'
      
    changeSelected: (model, options) ->
      @$el.toggleClass 'active', model.selected
      
    onRender: ->
      @$el.addClass 'active' if @model.selected
      
    select: (event) ->
      event.preventDefault()
      @model.select()
      
    deselect: (event) ->
      event.preventDefault()
      @model.deselect()