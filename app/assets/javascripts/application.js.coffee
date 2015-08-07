# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require foundation
#= require foundation-datepicker
#= require cocoon
#= require rails.validations
#= require toastr
#= require underscore
#= require backbone
#= require whois
#= require_tree ../templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers
#= require_tree .

$ ->
  $(document).foundation()
  
  $('.date-picker').fdatepicker().on 'changeDate', (ev) ->
    $(ev.target).change().focusout()
    
  $(document).on 'opened.fndtn.reveal', '[data-reveal]', ->
    $(this).find('form').validate()

@toggleTableRow = (css_selector, link) ->
  $row = $(css_selector)
  if $row.css('display') == 'none'
    $row.css('display', 'table-row')
    $(link).find('i').removeClass('fa-angle-down').addClass('fa-angle-up')
  else
    $row.css('display', 'none')
    $(link).find('i').removeClass('fa-angle-up').addClass('fa-angle-down')