// Only for Cardboard Admin Area
// see lib/cardboard/generators/cardboard/assets/templates for helpers
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/sortable
//= require cardboard/jquery.livesearch
//= require turbolinks
//= require lodash
//= require bootstrap-sprockets
//= require bootstrap/button
//= require bootstrap/dropdown
//= require bootstrap/modal
//= require bootstrap/alert
//= require bootstrap/tab
//= require cardboard/bootstrap-select
//= require bootstrap-datepicker/core
//= require cardboard/datepicker
//= require cardboard/rich_text
//= require cardboard/jquery.wysihtml5_size_matters
//= require cocoon
//= require cardboard/main_sidebar
//= require cardboard/content_sidebar
//= require cardboard/search_filter
//= require cardboard/responsive
//= require select2
// require cardboard/jquery.wysihtml5imgresizer


$(document).on('click', '.nav-tabs a', function(e){
  e.preventDefault();
  $(this).tab('show');
});

$(document).on("page:load ready cocoon:after-insert", function(e){
  window['rangy'].initialized = false;
  // TODO: Get rid of this, this is a hack to get around simple form and
  // bootstrap
  $('input.boolean, input.file, .time, .select, .bootstrap-select').removeClass('form-control');
  $('div.time label, .select label').after($("<br />"));

  $('select[data-search-select]').each(function() {
    var options = $(this).data("select2-options")
    $(this).select2($.extend({allowClear: true, width: "resolve"}, options));
  });
  $('select:not([data-search-select])').selectpicker();

  window.setTimeout(function() { $(".alert:not(.alert-danger)").alert('close'); }, 2000);
});
