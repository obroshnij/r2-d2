Backbone.Syphon.KeyAssignmentValidators.registerDefault ($el, key, value) ->
  # make sure that an empty array is returned if a set of checkboxes is shown but noting is checked
  return true if $el.attr('syphon') is 'visible' and $("[name='#{$el.attr('name')}']").is(':visible')
  $el.is(':visible')
  
Backbone.Syphon.KeyAssignmentValidators.register 'checkbox', ($el, key, value) ->
  $el.is(':visible') and $el.prop('checked')
  
Backbone.Syphon.KeyAssignmentValidators.register 'radio', ($el, key, value) ->
  $el.is(':visible') and $el.prop('checked')
  
Backbone.Syphon.InputReaders.register 'checkbox', (el) ->
  el.val()