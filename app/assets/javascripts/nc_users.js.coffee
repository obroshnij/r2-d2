# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  
  if gon.user_relations
  
    container = document.getElementById 'user-relations'

    options =
      clickToUse: true,
      edges:
        font:
          align: 'top',
          size: 8
      nodes:
        shape: 'dot'
        color:
          border: '#007095',
          background: '#008CBA',
          highlight:
            border: '#007095',
            background: '#007095'
        font:
          color: '#222222'
      
    graph =
      nodes: gon.user_relations.nodes,
      edges: gon.user_relations.edges
  
    network = new vis.Network container, graph, options