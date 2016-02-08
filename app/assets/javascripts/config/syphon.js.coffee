Backbone.Syphon.KeyAssignmentValidators.registerDefault ($el, key, value) ->
  # make sure that an empty array is returned if a set of checkboxes is shown but noting is checked
  return true if $el.attr('syphon') is 'visible' and $("[name='#{$el.attr('name')}']").is(':visible')
  
  # make sure that values of hidden inputs with the 'syphon' attribute are read
  return true if $el.attr('type') is 'hidden' and $el.attr('syphon') is 'always-visible'
  
  # don't read the field's value if it's hidden by default
  $el.is(':visible')
  
Backbone.Syphon.KeyAssignmentValidators.register 'checkbox', ($el, key, value) ->
  $el.is(':visible') and $el.prop('checked')
  
Backbone.Syphon.KeyAssignmentValidators.register 'radio', ($el, key, value) ->
  $el.is(':visible') and $el.prop('checked')


Backbone.Syphon.InputReaders.register 'checkbox', (el) ->
  el.val()


Backbone.Syphon.InputWriters.register 'checkbox', (el, value) ->
  array = _.map value, (element) -> element.toString()
  el.prop 'checked', _.contains(array, el.val())

Backbone.Syphon.InputWriters.register 'radio', (el, value) ->
  if value?.toString()
    el.prop 'checked', el.val() is value?.toString()

Backbone.Syphon.InputWriters.register 'hidden', (el, value) ->
  return