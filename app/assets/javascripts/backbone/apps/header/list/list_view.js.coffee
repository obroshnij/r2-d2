@Artoo.module 'HeaderApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Header extends App.Views.ItemView
    template: 'header/list/header'
    
    triggers:
      'click #sign-in' : 'sign:in:clicked'