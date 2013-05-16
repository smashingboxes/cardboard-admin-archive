// Only for Cardboard Admin Area
// see lib/cardboard/generators/cardboard/assets/templates for helpers
//
//= require jquery
//= require jquery_ujs
//= require cardboard/jquery.livesearch
//= require bootstrap-button
//= require bootstrap-dropdown
//= require bootstrap-modal
//= require bootstrap-alert
//= require bootstrap-tab
//= require cardboard/wysihtml5-0.4.0pre 
//= require bootstrap-wysihtml5/core
//= require bootstrap-datepicker
//= require cocoon
//= require cardboard/wysihtml5-setup


// // require jquery.pjax
// $(function(){
//   $('.wysihtml5').each(function(i, elem) {
//     $(elem).wysihtml5();
//   });

//   $('a:not([data-remote]):not([data-behavior]):not([data-skip-pjax])').pjax('[data-pjax-container]');
// })
$(function(){
  
  var $advanced_field_select = $("select#advanced_field");
  var $ransack_select = $("select#ransack_options")
  var $ransack_options = $("select#ransack_options").html();

  $advanced_field_select.change(function(){
    var type = $advanced_field_select.find(":selected").data("type");
    var options = $($ransack_options).filter("optgroup[label='" + type + "']").html()
    $ransack_select.html(options);
    $ransack_select.trigger("change");
  });
  $advanced_field_select.trigger("change");

  $ransack_select.change(function(){
    var field_name = $advanced_field_select.find(":selected").val() +"_" + $(this).val();
    $("#advanced_query").attr("name", "q["+field_name+"]").val("");
  });


  $("#advanced_search_link").click(function(){
    $("#simple_search").slideToggle();
    $("#advanced_search").slideToggle();
  });
  $("#simple_search_link").click(function(){
    $("#advanced_search").slideUp(function(){
      complete: $("#simple_search").slideDown();
    });
  });

  $(document).on('focus', '.datepicker:not(.hasDatepicker)', function(){
    $(this).datepicker({format: 'yyyy-mm-dd'});
  });

  $("a#nav_dashboard_link").click(function(e){
    e.preventDefault();
    $("#content_sidebar").toggle();
    $('#content').toggleClass('toggle');
    $(this).toggleClass('active');
  });


  $('.nav-tabs a').click(function (e) {
    e.preventDefault();
    $(this).tab('show');
  });
  $('.nav-tabs a:first').tab('show');


  // Filter page sidebar
  $('#sidebar_page_search').search('.indent', function(on) {
    on.all(function(results) {
      var size = results ? results.size() : 0
    });

    on.reset(function() {
      $('#sidebar_page_search_none').hide();
      $('.indent').show();
    });

    on.empty(function() {
      $('#sidebar_page_search_none').show();
      $('.indent').hide();
    });

    on.results(function(results) {
      $('#sidebar_page_search_none').hide();
      $('.indent').hide();
      results.show();
    });
  });

})
