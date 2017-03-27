@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.FormField extends App.Entities.Model

    defaults:
      tagName: 'input'
      type:    'text'

    mutators:
      elementId: ->
        @get('name') + '_' + @get('tagName')

      identifier: ->
        if @get('nested')
          "#{@get('nestName')}[#{@get('nestId')}][#{@get('name')}]"
        else
          @get('name')

      id: ->
        @get('identifier')

      columnClass: ->
        if @get('hasHint') then 'large-5' else 'large-12'

    @include 'DynamicFormElement'


  class Entities.FormFields extends App.Entities.Collection
    model: Entities.FormField


  class Entities.FormGroup extends App.Entities.Model

    defaults:
      markedForDestruction: false

    initialize: (attrs) ->
      fieldsAttrs = attrs.fields.map (f) =>
        f.isCompact = attrs.isCompact
        f.hasHint   = attrs.hasHints
        f.nested    = attrs.nested
        f.nestName  = attrs.name
        f.nestId    = @cid
        f
      @fields = new Entities.FormFields fieldsAttrs

      @listenTo @, 'mark:for:destruction', @markForDestruction

    mutators:

      isFirst: ->
        @collection.filter((m) -> !m.get('markedForDestruction'))[0]?.cid is @cid

      identifier: ->
        "#{@get('name')}[#{@cid}]"

    markForDestruction: ->
      @set 'markedForDestruction', true


  class Entities.FormGroups extends App.Entities.Collection
    model: Entities.FormGroup


  class Entities.Fieldset extends App.Entities.Model

    defaults:
      isCompact: false
      hasHints:  true
      nested:    false

    mutators:
      elementId: ->
        @get('id') + '_fieldset' if @get('id')

    getGroupAttrs: (attrs) ->
      _.defaults attrs,
        isCompact: @get('isCompact')
        hasHints:  @get('hasHints')
        nested:    @get('nested')
        name:      @get('name')

    initialize: (attrs) ->
      @groups = new Entities.FormGroups [@getGroupAttrs(attrs)]
      @unset 'fields'

      @listenTo @, 'add:group', () -> @addGroup(attrs)

    addGroup: (attrs) ->
      group = new Entities.FormGroup(this.getGroupAttrs(attrs))
      fieldValues = @collection.getFieldValues()
      group.fields.each (field) -> field.toggle(fieldValues)
      @groups.add group

    toggle: (fieldValues) ->
      @groups.each (group) ->
        group.fields.each (field) ->
          field.trigger 'toggle:fields', fieldValues

    @include 'DynamicFormElement'


  class Entities.Fieldsets extends App.Entities.Collection
    model: Entities.Fieldset

    initialize: ->
      @listenTo @, 'field:value:changed', @onFieldValueChange

    onFieldValueChange: ->
      fieldValues = @getFieldValues()
      model.trigger 'toggle:fields', fieldValues for model in @models

    getFieldValues: ->
      result = {}
      fields = _.chain(@models)
        .map((fieldset) -> fieldset.groups.models).flatten()
        .map((group) -> group.fields.models).flatten().value()
      _(fields).each (field) -> result[field.get('identifier')] = field.get('value')
      result


  API =

    newFieldsets: (params) ->
      new Entities.Fieldsets params


  App.reqres.setHandler 'init:form:fieldset:entities', (params) ->
    API.newFieldsets params
