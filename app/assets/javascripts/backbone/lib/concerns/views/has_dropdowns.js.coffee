@Artoo.module "Concerns", (Concerns, App, Backbone, Marionette, $, _) ->
  
  Concerns.HasDropdowns =
    
    onAttach: ->
      @dropdowns = @$(".dropdown-pane").map (index, element) ->
        new Foundation.Dropdown $(element)
      .toArray()
      
    onDestroy: ->
      _.each @dropdowns, (dropdown) -> dropdown.destroy()