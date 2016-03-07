@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.DirectoryGroup extends App.Entities.Model
    
  
  class Entities.DirectoryGroupsCollection extends App.Entities.Collection
    model: Entities.DirectoryGroup