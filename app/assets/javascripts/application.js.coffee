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
#= require jquery.tablesorter
#= require rails.validations
#= require rails.validations.actionView
#= require toastr
#= require vis.min
#= require spin
#= require underscore
#= require backbone
#= require whois
#= require_tree ../templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers

#= require abuse_reports
#= require domain_box
#= require la_tools
#= require manager_tools
#= require nc_users
#= require roles

String.prototype.capitalizeFirstLetter = ->
  @charAt(0).toUpperCase() + @slice(1)
  
String.prototype.humanize = ->
  $.map(@split('_'), (el, i) -> el.capitalizeFirstLetter() ).join(' ')

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
    
@spinner = (target) ->
  $(target).append('<br>')
  target = $(target)[0]
  spinner = new Spinner().spin(target)
  
