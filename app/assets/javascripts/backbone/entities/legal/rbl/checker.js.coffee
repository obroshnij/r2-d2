@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Rbl.CheckResult extends App.Entities.Model
    
    statusColorLookups: { 'Unimportant': 'primary', 'Urgent': 'alert', 'Important': 'warning' }
    resultColorLookups: { 'Listed': 'red', 'Not Listed': 'green', 'Skip': 'white', 'Failure': 'yellow' }
    
    mutators:
      
      statusColor: ->
        @statusColorLookups[@get('status')] if @get('status')
        
      resultColor: ->
        @resultColorLookups[@get('result')] if @get('result')
        
      formattedDetails: ->
        _.map @get('data'), (val, key) ->
          "#{key}: #{val}"
        .join("\n")
    
  
  class Entities.Rbl.CheckResultsCollection extends App.Entities.Collection
    model: Entities.Rbl.CheckResult
  
  
  class Entities.Rbl.Checker extends App.Entities.Model
    urlRoot: -> Routes.legal_rbl_checkers_path()
    
    initialize: ->
      @result = new Entities.Rbl.CheckResultsCollection @get('result')
      
      @listenTo @, 'created', =>
        @result.reset @get('result')
        @unset 'result'
    
    
  API =
    
    newChecker: (attrs) ->
      new Entities.Rbl.Checker attrs
      
  App.reqres.setHandler 'legal:rbl:checker:entity', (attrs = {}) ->
    API.newChecker attrs