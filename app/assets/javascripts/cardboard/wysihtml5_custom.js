
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

$(document).ready(function () {

  var TOOLBAR_CLASS = 'toolbar',
      TEXTAREA_CLASS = 'wysihtml5';

  $('.wysihtml5_wrapper').each(function (index) {

    var textarea_id = TEXTAREA_CLASS + '_' + index,
        toolbar_id = TOOLBAR_CLASS + '_' + index;
    
    var $wysihtml5 = $(this),
        $toolbar = $wysihtml5.find('.' + TOOLBAR_CLASS),
        $textarea = $wysihtml5.find('.' + TEXTAREA_CLASS),
        $insertBtn = $wysihtml5.find('.insert_image'),
        $modal = $wysihtml5.find('.image_modal'),
        $imageUrl = $wysihtml5.find('.image_url'),
        $saveBtn = $wysihtml5.find('.save_image');
 
    var caretPosition,
        editor;
    
    $textarea.attr('id', textarea_id);
    $toolbar.attr('id', toolbar_id);
  
    editor = new wysihtml5.Editor(textarea_id, {
      toolbar:        toolbar_id,
      // stylesheets:    "/assets/application.css",
      parserRules:    wysihtml5ParserRules
    });

    editor.on('load', function () {
      var editor = this;
      var caretPosition;
      
      initRichImages();
      
      $insertBtn.click(function () {
        caretPosition = editor.composer.selection.getBookmark();
        $imageUrl.val(null);
        $modal.modal('show');
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
  
  });
  
});
