@Artoo.module "Concerns", (Concerns, App, Backbone, Marionette, $, _) ->
  
  Concerns.HasDropdowns =
          
    onDestroy: ->
      @clearDropdowns()
      
    onDomRefresh: ->
      @clearDropdowns()
      @initDropdowns()
      
    initDropdowns: ->
      @dropdowns = @$(".dropdown-pane").map (index, element) ->
        new Foundation.Dropdown $(element)
      .toArray()
      
    clearDropdowns: ->
      _.each @dropdowns, (dropdown) -> dropdown.destroy() if @dropdowns