// Only for Cardboard Admin Area
// see lib/cardboard/generators/cardboard/assets/templates for helpers
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-button
//= require bootstrap-dropdown
//= require bootstrap-modal
//= require bootstrap-wysihtml5
//= require_tree .

$(function(){

  var page_links_template = {
    link: function(locale, options) {
      var size = (options && options.size) ? ' btn-'+options.size : '';
      return gon.rich_text_links_modal;
    }
  }

  $('.rich_text').each(function(i, elem) {
    $(elem).wysihtml5({"font-styles": false,"image": false, "customTemplates":  page_links_template});
  });

})