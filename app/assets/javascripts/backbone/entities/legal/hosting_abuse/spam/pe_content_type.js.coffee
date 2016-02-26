@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Spam.PeContentType extends App.Entities.Model
  
  
  class Entities.HostingAbuse.Spam.PeContentTypesCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.Spam.PeContentType
  
  
  API =
    
    newPeContentTypesCollection: (attrs = {}) ->
      new Entities.HostingAbuse.Spam.PeContentTypesCollection attrs
  
    
  App.reqres.setHandler 'legal:hosting:abuse:spam:pe:content:type:entities', ->
    API.newPeContentTypesCollection App.entities.legal.hosting_abuse.spam.pe_content_type