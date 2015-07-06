# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  
  @row = $(".role-row")
  
  $("td[data-action='read']").find("input[type='checkbox']").each ->
    toggleCRUDFields(this)
  
  toggleRolesRow()
  
  $("td[data-action='read']").find("input[type='checkbox']").change ->
    toggleCRUDFields(this)
  
  $("[data-resource='user'][data-action='read']").find("input[type='checkbox']").change ->
    toggleRolesRow()
    
@toggleCRUDFields = (element) ->
  resource = $(element).closest("td").attr("data-resource")
  $CUDActions = $(element).closest("tr").find("[data-resource='#{resource}'][data-action!='read']").find("input[type='checkbox']")
  unless $(element).prop("disabled")
    if $(element).prop("checked")
      $CUDActions.prop("disabled", false)
    else
      $CUDActions.prop("checked", false).prop("disabled", true)
    
@toggleRolesRow = ->
  if $("[data-resource='user'][data-action='read']").find("input[type='checkbox']").prop("checked")
    $(".user-row").after(@row)
    @row.show() if @row
  else
    $(".role-row").find("input[type='checkbox']").prop("checked", false)
    @row = $(".role-row").hide().detach()
    $("tbody").prepend(@row)