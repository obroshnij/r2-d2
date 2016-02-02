@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Spam.ContentType extends App.Entities.Model
  
  
  class Entities.HostingAbuse.Spam.ContentTypesCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.Spam.ContentType
  
  
  API =
    
    newContentTypesCollection: (attrs = {}) ->
      new Entities.HostingAbuse.Spam.ContentTypesCollection attrs
  
    
  App.reqres.setHandler 'legal:hosting:abuse:spam:content:type:entities', ->
    API.newContentTypesCollection App.entities.legal.hosting_abuse.spam.content_type