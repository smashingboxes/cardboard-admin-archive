// Only for Cardboard Admin Area
//
//= require jquery
//= require jquery_ujs
//= require jquery.pjax
//= require bootstrap-button
//= require bootstrap-dropdown
//= require bootstrap-wysihtml5
//= require_tree .

$(function(){

  $('.wysihtml5').each(function(i, elem) {
    $(elem).wysihtml5();
  });

  $('a:not([data-remote]):not([data-behavior]):not([data-skip-pjax])').pjax('[data-pjax-container]');
  
})