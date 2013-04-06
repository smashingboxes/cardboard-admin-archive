// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
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