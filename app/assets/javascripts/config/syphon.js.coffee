Backbone.Syphon.InputReaders.register 'checkbox', (el) ->
  el.val()

Backbone.Syphon.KeyAssignmentValidators.register 'checkbox', ($el, key, value) ->
  $el.prop 'checked'

Backbone.Syphon.ignoredTypes.push ':hidden:not([syphon="visible"])'
  
Backbone.Syphon.KeyAssignmentValidators.register 'hidden', ($el, key, value) ->
  $el.closest('div').is ':visible'