@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.EmailVerificationRecord extends App.Entities.Model
        
    mutators:
      
      _isYellow: ->
        rcptToLine = _.last @get('session')?.rcpt_to
        (_.isNull(rcptToLine) or _.isUndefined(rcptToLine)) and @get('host_error') is 'Uncommon error, see session logs'
      
      mailboxColor: ->
        return 'yellow' if @get('_isYellow')
        return 'grey'   if @get('host_error')
        if @get('mailbox_error') then 'red' else 'green'
        
      hostColor: ->
        return 'yellow' if @get('_isYellow')
        if @get('host_error') then 'red' else 'green'
        
      statusColor: ->
        return 'yellow' if @get('_isYellow')
        if @get('host_error') or @get('mailbox_error') then 'red' else 'green'
        
  
  class Entities.EmailVerificationRecords extends App.Entities.Collection
    model: Entities.EmailVerificationRecord
  
  
  class Entities.EmailVerifier extends App.Entities.Model
    urlRoot: -> Routes.tools_email_verifiers_path()
    
    initialize: ->
      @records = new Entities.EmailVerificationRecords
      @listenTo @, 'change:records', -> @records.reset @get('records')
    
      
  API =
    
    newEmailVerifier: (attrs) ->
      new Entities.EmailVerifier attrs
      
      
  App.reqres.setHandler 'email:verifier:entity', (attrs = {}) ->
    API.newEmailVerifier attrs