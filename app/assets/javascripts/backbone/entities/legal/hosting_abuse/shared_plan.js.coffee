@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.SharedPlan extends App.Entities.Model
  
  
  class Entities.HostingAbuse.SharedPlansCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.SharedPlan
  
   
  API =
    
    newSharedPlansCollection: (attrs = {}) ->
      new Entities.HostingAbuse.SharedPlansCollection attrs
  
      
  App.reqres.setHandler 'legal:hosting:abuse:shared:plan:entities', ->
    API.newSharedPlansCollection App.entities.legal.hosting_abuse.shared_plan