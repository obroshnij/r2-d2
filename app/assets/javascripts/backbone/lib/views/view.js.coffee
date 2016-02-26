@Artoo.module 'Views', (Views, App, Backbone, Marionette, $, _) ->
  
  _destroy = Marionette.View::destroy
  
  _.extend Marionette.View::,
  
    addOpacityWrapper: (init = true, options = {}) ->
      _.defaults options,
        className: "opacity"

      @$el.toggleWrapper options, @cid, init
  
    destroy: (args...) ->
      if @model?.isDestroyed()
                  
        wrapper = @addOpacityWrapper true,
          backgroundColor: "#ec5840"
        
        wrapper.fadeOut 400, ->
          $(@).remove()
          
        @$el.fadeOut 400, =>
          _destroy.apply @, args
          
      else
        _destroy.apply @, args
    
    templateHelpers: ->
      
      currentUser:
        App.request('get:current:user')?.toJSON() ? false
        
      can: (action, subject) ->
        App.request('get:current:ability').can action, subject
        
      cannot: (action, subject) ->
        App.request('get:current:ability').cannot action, subject
        
      linkTo: (name, url, options = {}, html_options = {}) ->
        
        _.defaults options,
          external: false
        
        unless _.isEmpty html_options
          attributes = _.map html_options, (val, key) ->
            "#{key}='#{val}'"
          .join(' ')
        
        url = '#' + url unless options.external
        
        "<a href='#{url}' #{attributes}>#{@escape(name)}</a>"
        
      rootRoute:
        App.request 'get:root:route'
        
      truncate: (text, length = 20, dropdown = false) ->
        result = @escape s.truncate(text, length)
        
        if dropdown and s.endsWith(result, '...')
          id = _.uniqueId('drop-')
          result = "<span>
            #{result}
            <a data-toggle='#{id}'>more</a>
            <div class='dropdown-pane left' id='#{id}' data-dropdown data-hover='true' data-hover-pane='true'>#{text}</div>
          </span>"
        
        result
        
      dropdown: (label, text) ->
        id = _.uniqueId('drop-')
        "<span>
          <a data-toggle='#{id}'>#{label}</a>
          <div class='dropdown-pane' id='#{id}' data-dropdown data-hover='true' data-hover-pane='true'>#{text}</div>
        </span>"