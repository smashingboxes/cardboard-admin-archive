// Only for Cardboard Admin Area
// see lib/cardboard/generators/cardboard/assets/templates for helpers
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-button
//= require bootstrap-dropdown
//= require bootstrap-wysihtml5
//= require_tree .

$(function(){

  $('.wysihtml5').each(function(i, elem) {
    $(elem).wysihtml5();
  });

})