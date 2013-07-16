var wysihtml5ParserRules = {
  /**
   * CSS Class white-list
   * Following CSS classes won't be removed when parsed by the wysihtml5 HTML parser
   */
  "classes": {
      "wysiwyg-clear-both": 1,
      "wysiwyg-clear-left": 1,
      "wysiwyg-clear-right": 1,
      "wysiwyg-float-left": 1,
      "wysiwyg-float-right": 1,
      "wysiwyg-text-align-center": 1,
      "wysiwyg-text-align-justify": 1,
      "wysiwyg-text-align-left": 1,
      "wysiwyg-text-align-right": 1
  },
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

var wysihtml5_initializer = function(element){
  var caretPosition, editor;
  
  var $wysihtml5 = $(element),
      $toolbar = $wysihtml5.find('.toolbar'),
      $textarea = $wysihtml5.find('.wysihtml5'),
      $insertBtn = $wysihtml5.find('.insert_image'),
      $modal = $wysihtml5.find('.image_modal'),
      $imageUrl = $wysihtml5.find('.image_url'),
      $saveBtn = $wysihtml5.find('.save_image');

  editor = new wysihtml5.Editor($textarea.get()[0], {
    toolbar:        $toolbar.get()[0],
    // stylesheets:    "/assets/application.css",
    parserRules:    wysihtml5ParserRules
  });

  editor.on('load', function () {
    
    $(editor.composer.iframe).wysihtml5_size_matters();

    initRichImages();
    
    $insertBtn.click(function () {
      caretPosition = editor.composer.selection.getBookmark();
      $imageUrl.val(null);
      $modal.modal('show');
    });

    $toolbar.find("a[data-wysihtml5-command='formatBlock']").click(function(e) {
      var target = e.target || e.srcElement;
      var el = $(target);
      $toolbar.find('.current-font').text(el.html());
    });
    
    $modal.on('shown', function () {
      $imageUrl.focus();
    })
    
    $saveBtn.click((function(editor) {
      return function (e) {
        
        if (caretPosition) {
          editor.composer.selection.setBookmark(caretPosition);
          editor.currentView.element.focus();
          editor.composer.commands.exec('insertImage', {src: $imageUrl.val()});
          initRichImages();
        }

        $modal.modal('hide');
        
      };
    })(editor));
  });
  
  editor.on('change_view', function () {
    initRichImages();
  });
  editor.on('paste:composer', function () {
    initRichImages();
  });
  editor.on('undo:composer', function () {
    initRichImages();
  });
  editor.on('redo:composer', function () {
    initRichImages();
  });
  
  function initRichImages() {
    setTimeout(function () {
      $(editor.composer.iframe.contentWindow.document).find("img").wysihtml5ImgResizer({
        document: editor.composer.iframe.contentWindow.document
      });
    }, 0)
  }
};

$(document).on("ready pjax:end", function () {

  $(document).on('cocoon:after-insert', function(e, insertedItem) {
    if($(insertedItem).find(".wysihtml5_wrapper").length){
      wysihtml5_initializer(insertedItem);
    }
    // $(insertedItem).find("textarea").wysihtml5({"image": false, "customTemplates":  page_links_template});
  });

  $('.wysihtml5_wrapper').each(function() {
    if($(".wysihtml5_wrapper").length){
      wysihtml5_initializer(this);
    }
  });
  
});
