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
//= require cardboard/wysihtml5-0.4.0pre 
//= require bootstrap-wysihtml5/core
//= require bootstrap-datepicker/core
//= require cocoon
//= require cardboard/wysihtml5-setup
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
    $('.nav_resource_link.active, #nav_dashboard_link').removeClass('active');
    $(this).addClass('active');
  });

  $(document).on('focus', '.datepicker:not(.hasDatepicker)', function(){
    $(this).datepicker({format: 'yyyy-mm-dd'});
  });

  $(document).on('click', '.nav-tabs a', function(e){
    e.preventDefault();
    $(this).tab('show');
  });
  
  $('.nav-tabs a:first').tab('show');

//   $('.wysihtml5').each(function(i, elem) {
//     $(elem).wysihtml5();
//   });

})
