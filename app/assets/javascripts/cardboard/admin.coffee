# Only for Cardboard Admin Area
# see lib/cardboard/generators/cardboard/assets/templates for helpers
#
#= require jquery
#= require jquery_ujs
#= require jquery-ui/sortable
#= require cardboard/jquery.livesearch
#= require turbolinks
#= require cardboard/datepicker
#= require cardboard/jquery.wysihtml5_size_matters
#= require cocoon
#= require cardboard/main_sidebar
#= require cardboard/content_sidebar
#= require cardboard/search_filter
#= require cardboard/top-bar
#= require select2
#= require cardboard/jquery.wysihtml5imgresizer


$(document).on 'click', '.nav-tabs a', (e) ->
  e.preventDefault()
  $(@).tab 'show'
  return
$(document).on 'page:load ready cocoon:after-insert', (e) ->
  $('select[data-search-select]').each ->
    options = $(@).data('select2-options')
    $(@).select2 $.extend({
      allowClear: true
      width: 'resolve'
    }, options)
    return
  $('select:not([data-search-select])').selectpicker()
  $('.nav-tabs a:first').tab 'show'
  window.setTimeout (->
    $('.alert:not(.alert-error)').alert 'close'
    return
  ), 2000
  return

