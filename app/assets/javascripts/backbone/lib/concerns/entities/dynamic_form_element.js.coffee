@Artoo.module "Concerns", (Concerns, App, Backbone, Marionette, $, _) ->

  Concerns.DynamicFormElement =

    defaults:
      isShown: true

    checkers:

      value: (allowed, current) ->
        allowed      = _.chain([allowed]).flatten().compact().map( (el) -> el.toString() ).value()
        current      = _.chain([current]).flatten().compact().map( (el) -> el.toString() ).value()
        intersection = _.intersection allowed, current
        not _.isEmpty(intersection)

    initialize: ->
      @listenTo @, 'toggle:fields', @toggle
      @listenTo @, 'toggle:fields', @runCallback
      @listenTo @, 'change:value',  @onChange

    dependenciesAreSatisfied: (fieldValues) ->
      return true                               unless  @attributes.dependencies
      return @_verifyDependencies(fieldValues)  if      _.isArray  @attributes.dependencies
      return @_verifyDependency(fieldValues)    if      _.isObject @attributes.dependencies

    _verifyDependencies: (fieldValues) ->
      result = _.map @attributes.dependencies, (dependency) =>
        @_verifyDependency(fieldValues, dependency)

      _.chain(result)
        .inject (memo, val) -> memo or val
          .value()

    _verifyDependency: (fieldValues, dependency) ->
      dependency ?= @attributes.dependencies

      result = _.map dependency, (conditions, parent) =>
        parentName = if this.get('nested') and this.get('identifier') and parent.indexOf("#{this.get('nestName')}.") is 0
          this.get('identifier').replace new RegExp(this.get('name')), parent.replace(new RegExp("#{this.get('nestName')}."), '')
        else
          parent

        _.map conditions, (allowedValues, checker) =>
          @checkers[checker](allowedValues, fieldValues[parentName])

      _.chain(result)
        .flatten()
          .inject (memo, val) -> memo and val
            .value()

    toggle: (fieldValues) ->
      if @dependenciesAreSatisfied(fieldValues) then @show() else @hide()

    runCallback: (fieldValues) ->
      return unless @get('callback')
      callback = _.bind @get('callback'), @
      callback fieldValues

    onChange: ->
      @get('onChange') and @get('onChange').call(@)

    show: ->
      if @isHidden()
        @set 'isShown', true
        @trigger 'show'

    isShown: ->
      @get 'isShown'

    hide: ->
      if @isShown()
        @set 'isShown', false
        @trigger 'hide'

    isHidden: ->
      not @isShown()

    isCompact: ->
      @get 'isCompact'
