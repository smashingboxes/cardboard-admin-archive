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

$(document).on("ready page:load", function(e){
  if($(".wysihtml5").length) {
    $('.wysihtml5').wysihtml5(rich_text_editor_defaults);
    $('iframe.wysihtml5-sandbox').wysihtml5_size_matters();

    // TODO: find a better way to handle multiple RTE on a single page
    $(".bootstrap-wysihtml5-insert-link-modal .tab-content div").each(function (index) {
      $(this).attr("id", $(this).attr("id") + index.toString());            
    });
    $(".bootstrap-wysihtml5-insert-link-modal .nav li a").each(function (index) {
      $(this).attr("href", $(this).attr("href") + index.toString());
      if(index % 3 == 0) $(this).tab('show');
    });
    // END TODO
  }
});

$(document).on('cocoon:after-insert', function(e, insertedItem) {
  if($(insertedItem).find(".wysihtml5").length){
    $(insertedItem).find(".wysihtml5").wysihtml5(rich_text_editor_defaults);
  }
});



$(document).on('click', '.bootstrap-wysihtml5-insert-link-modal .link_pages a', function(e){
  e.preventDefault();
  console.log("clicked");
  modal = $(this).closest(".bootstrap-wysihtml5-insert-link-modal");
  modal.find("input.bootstrap-wysihtml5-insert-link-url").val($(this).data("url"));
  modal.find("#insert_link").click();
});

$(document).on('change', '.bootstrap-wysihtml5-insert-link-modal .tab-pane input', function(){
  $(this).closest('.bootstrap-wysihtml5-insert-link-modal').find('.bootstrap-wysihtml5-insert-link-url').val($(this).val());
});
