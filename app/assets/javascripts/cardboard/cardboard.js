// Only for Cardboard Admin Area
// see lib/cardboard/generators/cardboard/assets/templates for helpers
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-button
//= require bootstrap-dropdown
//= require bootstrap-modal
//= require bootstrap-alert
//= require bootstrap-wysihtml5
//= require bootstrap-datepicker
//= require cocoon

$(function(){

  $(document).on('focus', '.datepicker:not(.hasDatepicker)', function(){
    $(this).datepicker({format: 'yyyy-mm-dd'});
  });

  ////
  // Rich text editor
  var page_links_template = {
    link: function(locale, options) {
      var size = (options && options.size) ? ' btn-'+options.size : '';
      return gon.rich_text_links_modal;
    }
  }
  $('.rich_text').wysihtml5({"image": false, "customTemplates":  page_links_template});

  $(document).on('cocoon:after-insert', function(e, insertedItem) {
    $(insertedItem).find("textarea").wysihtml5({"image": false, "customTemplates":  page_links_template});
  });
  $(document).on('cocoon:before-insert', function(e,insertedItem) {
    insertedItem.fadeIn('slow');
  });

  $(document).on('click', '.bootstrap-wysihtml5-insert-link-modal a', function(e){
    $(this).closest(".bootstrap-wysihtml5-insert-link-modal").find("input.bootstrap-wysihtml5-insert-link-url").val($(this).data("url"));
    e.preventDefault;
    return false;
  });
  // End Rich Text Editor
})
