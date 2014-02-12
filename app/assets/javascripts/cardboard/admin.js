// Only for Cardboard Admin Area
// see lib/cardboard/generators/cardboard/assets/templates for helpers
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.sortable
//= require cardboard/jquery.livesearch
//= require turbolinks
//= require bootstrap-button
//= require bootstrap-dropdown
//= require bootstrap-modal
//= require bootstrap-alert
//= require bootstrap-tab
//= require cardboard/bootstrap-select
//= require bootstrap-datepicker/core
//= require cardboard/datepicker
//= require cardboard/rich_text
//= require cardboard/jquery.wysihtml5_size_matters
//= require cocoon
//= require cardboard/main_sidebar
//= require cardboard/content_sidebar
//= require cardboard/search_filter
//= require select2
// require cardboard/jquery.wysihtml5imgresizer


$(document).on('click', '.nav-tabs a', function(e){
  e.preventDefault();
  $(this).tab('show');
});

$(document).on("page:load ready cocoon:after-insert", function(e){

  $('select:not([data-search-select])').selectpicker();
  $('select[data-search-select]').select2({allowClear: true, width: "resolve"});

  $('.nav-tabs a:first').tab('show');

  window.setTimeout(function() { $(".alert:not(.alert-error)").alert('close'); }, 2000);
});

