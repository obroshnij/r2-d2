@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Compensation.IssueLevel extends App.Entities.Model


  class Entities.Compensation.IssueLevelsCollection extends App.Entities.Collection
    model: Entities.Compensation.IssueLevel


  API =

    newIssueLevelsCollection: (attrs = {}) ->
      new Entities.Compensation.IssueLevelsCollection attrs


  App.reqres.setHandler 'domains:compensation:issue:level:entities', ->
    API.newIssueLevelsCollection App.entities.domains.compensation.issue_level
