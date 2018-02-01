@Artoo.module 'ToolsCannedRepliesApp.Import', (Import, App, Backbone, Marionette, $, _) ->

  class Import.Controller extends App.Controllers.Application

    initialize: (options) ->

      model  = App.request 'import:canned_replies:entity'

      importView = @getImportView(model)

      form = App.request 'form:component', importView,
        proxy:     'modal'
        model:      model
        onCancel:  => @region.empty()
        onSuccess: => @region.empty()

      @show form

    getImportView: (model) ->
      schema = new Import.Schema

      App.request 'form:fields:component',
        proxy:  'modal'
        schema: schema,
        model:  model
