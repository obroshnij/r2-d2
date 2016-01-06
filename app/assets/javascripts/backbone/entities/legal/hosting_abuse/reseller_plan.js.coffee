@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.ResellerPlan extends App.Entities.Model
  
  
  class Entities.HostingAbuse.ResellerPlansCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.ResellerPlan
  
   
  API =
    
    newResellerPlansCollection: (attrs = {}) ->
      new Entities.HostingAbuse.ResellerPlansCollection attrs
  
    
  App.reqres.setHandler 'legal:hosting:abuse:reseller:plan:entities', ->
    API.newResellerPlansCollection App.entities.legal.hosting_abuse.reseller_plan