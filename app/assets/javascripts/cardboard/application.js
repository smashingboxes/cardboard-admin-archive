// Only for Cardboard Admin Area
// see lib/cardboard/generators/cardboard/assets/templates for helpers
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-button
//= require bootstrap-dropdown
//= require bootstrap-modal
//= require bootstrap-wysihtml5
//= require cocoon

$(function(){

  ////
  // Rich text editor
  var page_links_template = {
    link: function(locale, options) {
      var size = (options && options.size) ? ' btn-'+options.size : '';
      return gon.rich_text_links_modal;
    }
  }
  $('.rich_text').wysihtml5({"image": false, "customTemplates":  page_links_template});

  $(document).bind('cocoon:after-insert', function(e, insertedItem) {
    $(insertedItem).find("textarea").wysihtml5({"image": false, "customTemplates":  page_links_template});
  });
  $(document).bind('cocoon:before-insert', function(e,insertedItem) {
    insertedItem.fadeIn('slow');
  });
  // End Rich Text Editor
})
