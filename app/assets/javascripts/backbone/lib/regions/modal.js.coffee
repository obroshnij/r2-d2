@Artoo.module 'Regions', (Regions, App, Backbone, Marionette, $, _) ->
  
  class Regions.Modal extends Marionette.Region
      
    attachHtml: (view) ->
      @_options = @getDefaultOptions _.result(view, 'modal')
      super
      
    onShow: (view) ->
      @setUpBindings view
      @openModal()
    
    getDefaultOptions: (options = {}) ->
      _.defaults options,
        title:      '<br>',
        size:       'small',
        modalClass: options.className ? ''
      
    setUpBindings: (view) ->
      @listenTo view, 'modal:close', @empty
            
    openModal: ->
      @$el.on 'closed.zf.reveal', => @empty()
      @$el
        .addClass('reveal')
          .addClass(@_options.size)
            .addClass(@_options.modalClass)
              .prepend("<p class='lead'>#{@_options.title}</p>")
                .append("<button class='close-button' data-close aria-label='Close reveal' type='button'><span aria-hidden='true'>&times;</span></button>")
      
      @modal = new Foundation.Reveal @$el
      @modal.open()
      
    onEmpty: ->
      @$el.off 'closed.zf.reveal'
      @$el.removeClass()
      @stopListening()
      @modal.close()
      @modal.destroy()