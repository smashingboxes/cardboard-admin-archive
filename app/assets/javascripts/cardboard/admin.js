// Only for Cardboard Admin Area
// see lib/cardboard/generators/cardboard/assets/templates for helpers
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.sortable
//= require cardboard/jquery.livesearch
//= require cardboard/jquery.pjax
//= require bootstrap-button
//= require bootstrap-dropdown
//= require bootstrap-modal
//= require bootstrap-alert
//= require bootstrap-tab
//= require cardboard/bootstrap-select
//= require bootstrap-datepicker/core
//= require cardboard/wysihtml5-0.4.0pre 
//= require cardboard/jquery.wysihtml5imgresizer
//= require cardboard/jquery.wysihtml5_size_matters
//= require cardboard/wysihtml5_custom
//= require cocoon
//= require cardboard/main_sidebar
//= require cardboard/content_sidebar
//= require cardboard/search_filter


$(function(){
  $(document).pjax('a:not([data-remote]):not([data-behavior]):not([data-skip-pjax]):not([href="#"]):not([href=""]):not([data-method])', '[data-pjax-container]');

  $(document).on('submit', 'form[data-pjax]', function(event) {
    $.pjax.submit(event, '[data-pjax-container]');
  });

  $('.page_link .link_wrap a').click(function(){
    $('.nav_resource_link.active').removeClass('active');
    $('#nav_dashboard_link').addClass('active');
  });

  $('.nav_resource_link').click(function(){
    $('.nav_resource_link.active, .nav_dashboard_link').removeClass('active');
    $(this).addClass('active');
  });

  $(document).on('focus', '.datepicker:not(.hasDatepicker)', function(){
    $(this).datepicker({format: 'yyyy-mm-dd'});
  });

  $(document).on('click', '.nav-tabs a', function(e){
    e.preventDefault();
    $(this).tab('show');
  });

  $(document).on('cocoon:before-insert', function(e,insertedItem) {
    insertedItem.fadeIn('slow');
  });

//   $('.wysihtml5').each(function(i, elem) {
//     $(elem).wysihtml5();
//   });

  $(document).on("pjax:end ready", function(e){
    $('select').selectpicker();

    $('.nav-tabs a:first').tab('show');
  });

})
