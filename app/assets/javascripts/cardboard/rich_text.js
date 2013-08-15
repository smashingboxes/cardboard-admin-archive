//= require cardboard/wysihtml5-0.4.0pre 
//= require bootstrap-wysihtml5/core

$(document).on('page:load', function(){
  window['rangy'].initialized = false
})

var wysihtml5ParserRules = {
  tags: {
      "b":  {},
      "i":  {},
      "br": {},
      "ol": {},
      "ul": {},
      "li": {},
      "h1": {},
      "h2": {},
      "h3": {},
      "blockquote": {},
      "u": 1,
      "img": {
          "check_attributes": {
              "width": "numbers",
              "alt": "alt",
              "src": "url",
              "height": "numbers"
          }
      },
      "a":  {
          set_attributes: {
              target: "_blank",
              // rel:    "nofollow"
          },
          check_attributes: {
              href:   "href" // important to avoid XSS
          }
      },
      "span": 1,
      "div": 1,
      // to allow save and edit files with code tag hacks
      "code": 1,
      "pre": 1
  }
};


var page_links_template = {
  link: function() { return gon.rich_text_links_modal; }
}

var rich_text_editor_defaults = {
  image: false, 
  customTemplates:  page_links_template, 
  parserRules: wysihtml5ParserRules, 
  useLineBreaks: false
}

$(document).on("ready pjax:end", function(e){
  console.log($(".wysihtml5").length);
  if($(".wysihtml5").length) {
    $('.wysihtml5').wysihtml5(rich_text_editor_defaults);
  }
});

$(document).on('cocoon:after-insert', function(e, insertedItem) {
  if($(insertedItem).find(".wysihtml5").length){
    $(insertedItem).find(".wysihtml5").wysihtml5(rich_text_editor_defaults);
  }
});

$(document).on('click', '.bootstrap-wysihtml5-insert-link-modal #link_pages a', function(e){
  e.preventDefault;
  modal = $(this).closest(".bootstrap-wysihtml5-insert-link-modal");
  modal.find("input.bootstrap-wysihtml5-insert-link-url").val($(this).data("url"));
  modal.find("#insert_link").click();
  return false;
});

$(document).on('change', '.bootstrap-wysihtml5-insert-link-modal .tab-pane input', function(){
  $(this).closest('.bootstrap-wysihtml5-insert-link-modal').find('.bootstrap-wysihtml5-insert-link-url').val($(this).val());
});
