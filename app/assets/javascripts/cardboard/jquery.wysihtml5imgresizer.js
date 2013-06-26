//
// Author: Pierre Lebrun
// Email: anthonylebrun@gmail.com
// Company: SmashingBoxes (http://smashingboxes.com)
//

;(function ($) {

  var wysihtml5ImgResizer = {
    defaults: {
      theme: {
        color: '#fff',
        background: '#FD0752'
      },
      document: document
    }
  };

  /********************/
  /* Plugin Interface */
  /********************/

  wysihtml5ImgResizer.publicMethods = {

    initialize: function (options) {
      return this.each(function () {
        var $this = $(this);

        if ($this.data('wysihtml5resizer') == null) {          
          var wysihtml5resizer = $.extend({}, wysihtml5ImgResizer.privateMethods);
          var settings = $.extend({}, wysihtml5ImgResizer.defaults, options || {})
          wysihtml5resizer.initialize(this, settings);
          $this.data('wysihtml5resizer', wysihtml5resizer);
        }
      });
    }
  };

  /******************************/
  /* Private (instance) methods */
  /******************************/

  wysihtml5ImgResizer.privateMethods = {

    initialize: function (el, settings) {
      this.$el = $(el);
      this.settings = settings;
      this.visible = null;

      this.$wrapperDiv = $('<div class="rr-wrapper"></div>');
      this.$removeDiv = $('<div class="rr-remove">&#215;</div>');
      this.$rightDiv = $('<div class="rr-right">&rarr;</div>');
      this.$leftDiv = $('<div class="rr-left">&larr;</div>');
      this.$rightResizeDiv = $('<div class="rr-resize-right">&#10537;</div>');
      this.$leftResizeDiv = $('<div class="rr-resize-right">&#10537;</div>');
      
      if (this.float() != 'right') {
        this.float('left');
      }
      
      this.selectable();
      this.deselectable();
    },
    
    selectable: function () {
      this.$el.click($.proxy(function () {
        if (!this.visible) {
          this.addInterface();
        }
      }, this));
    },
    
    deselectable: function () {
      $(this.settings.document).on('click', $.proxy(function(e) {
        var $clicked = $(e.target);
        if (!$clicked.closest(this.$wrapperDiv).length) {
          this.removeInterface();
        }
      }, this));
    },
    
    addInterface: function () {
      this.appendHTML();

      this.$el.css({'margin': '0px'});

      this.removable();
      this.floatable();
      this.resizable();
      
      if (this.float() == 'right') {
        this.float('right');
        this.$leftDiv.show();
        this.$leftResizeDiv.show();
      } else {
        this.float('left');
        this.$rightDiv.show();
        this.$rightResizeDiv.show();
      }
      
      this.visible = true;
    },
    
    removeInterface: function () {
      this.$el.unwrap();
      this.$removeDiv.remove();
      this.$rightDiv.remove();
      this.$leftDiv.remove();
      this.$rightResizeDiv.remove();
      this.$leftResizeDiv.remove();

      this.$el.attr('style', null);

      this.visible = false;
    },
    
    appendHTML: function () {

      this.$wrapperDiv.css({
        'display': 'inline-block',
        'position': 'relative',
        '-moz-box-sizing': 'border-box',
        '-webkit-box-sizing': 'border-box',
        '-webkit-user-select': 'none',
        '-moz-user-select': 'none',
        '-ms-user-select': 'none',
        'user-select': 'none'
      });
      
      this.$el.wrap(this.$wrapperDiv);
      this.$wrapperDiv = this.$el.parent();
      
      this.$removeDiv.appendTo(this.$wrapperDiv).css({
        'position': 'absolute',
        'top': '0px',
        'left': '0px',
        'width': '30px',
        'height': '30px',
        '-moz-box-sizing': 'border-box',
        '-webkit-box-sizing': 'border-box',
        'padding': '4px 8px',
        'font-family': 'Tahoma, Geneva, sans-serif',
        'font-size': '20px',
        'background': this.settings.theme.background,
        'color': this.settings.theme.color,
        'cursor': 'pointer'
      });
      
      this.$rightDiv.appendTo(this.$wrapperDiv).css({
        'display': 'none',
        'position': 'absolute',
        'top': '44%',
        'right': '0px',
        'width': '30px',
        'height': '30px',
        '-moz-box-sizing': 'border-box',
        '-webkit-box-sizing': 'border-box',
        'padding': '5px 6px',
        'font-family': 'Tahoma, Geneva, sans-serif',
        'font-size': '20px',
        'background': this.settings.theme.background,
        'color': this.settings.theme.color,
        'cursor': 'pointer'
      }).hide();
      
      this.$leftDiv.appendTo(this.$wrapperDiv).css({
        'display': 'none',
        'position': 'absolute',
        'top': '44%',
        'left': '0px',
        'width': '30px',
        'height': '30px',
        '-moz-box-sizing': 'border-box',
        '-webkit-box-sizing': 'border-box',
        'padding': '3px 6px',
        'font-family': 'Tahoma, Geneva, sans-serif',
        'font-size': '20px',
        'background': this.settings.theme.background,
        'color': this.settings.theme.color,
        'cursor': 'pointer'
      }).hide();
      
      this.$rightResizeDiv.appendTo(this.$wrapperDiv).css({
        'display': 'none',
        'position': 'absolute',
        'bottom': '0px',
        'right': '0px',
        'width': '30px',
        'height': '30px',
        '-moz-box-sizing': 'border-box',
        '-webkit-box-sizing': 'border-box',
        'padding': '2px 5px',
        'font-family': 'Tahoma, Geneva, sans-serif',
        'font-size': '20px',
        'background': this.settings.theme.background,
        'color': this.settings.theme.color,
        'cursor': 'pointer'
      });
      
      this.$leftResizeDiv.appendTo(this.$wrapperDiv).css({
        'display': 'none',
        'position': 'absolute',
        'bottom': '0px',
        'left': '0px',
        'width': '30px',
        'height': '30px',
        '-moz-box-sizing': 'border-box',
        '-webkit-box-sizing': 'border-box',
        'padding': '2px 5px',
        'font-family': 'Tahoma, Geneva, sans-serif',
        'font-size': '20px',
        'background': this.settings.theme.background,
        'color': this.settings.theme.color,
        'cursor': 'pointer'
      });
    },
    
    resizable: function () {
      
      var startX;
      var imageWidth;
      var mouseIsDown;
      var mouseSide;
      
      var mouseDownCallback = $.proxy(function (e) {
        startX = e.pageX;
        imageWidth = this.$el.width();
        mouseIsDown = true;
      }, this);
      
      this.$leftResizeDiv.on('mousedown', mouseDownCallback);
      this.$rightResizeDiv.on('mousedown', mouseDownCallback);
      
      $(this.settings.document).on('mouseup', function (e) {
        mouseIsDown = false;
      });
      
      $(this.settings.document).on('mousemove', $.proxy(function (e) {
        if (mouseIsDown) {
          if (this.float() == 'left') {
            this.$el.attr('width', (imageWidth + (e.pageX  - startX)));
          } else if (this.float() == 'right') {
            this.$el.attr('width', (imageWidth + (startX - e.pageX)));
          }
        }
      }, this));
    },
    
    removable: function () {
      this.$removeDiv.click($.proxy(function () {
        this.$wrapperDiv.remove();
      }, this));
    },
    
    floatable: function () {
      this.$rightDiv.click($.proxy(function () {
        this.float('right');
      }, this));
      
      this.$leftDiv.click($.proxy(function () {
        this.float('left');
      }, this));
    },
    
    float: function (side) {
      
      if (side) {
        this.$el.addClass('wysiwyg-float-' + side).removeClass('wysiwyg-float-' + this._opposite(side));
        this.$wrapperDiv.addClass('wysiwyg-float-' + side).removeClass('wysiwyg-float-' + this._opposite(side));
      }
      
      if(side == 'left') {
        
        this.$rightDiv.show();
        this.$leftDiv.hide();
        
        this.$rightResizeDiv.show();
        this.$leftResizeDiv.hide();
        
      } else if (side == 'right') {
        
        this.$leftDiv.show();
        this.$rightDiv.hide();
        
        this.$leftResizeDiv.show();
        this.$rightResizeDiv.hide();
        
      }
      
      if (this.$el.hasClass('wysiwyg-float-left')) {
        return 'left';
      } else if (this.$el.hasClass('wysiwyg-float-right')) {
        return 'right';
      }
      
    },
    
    // helpers (utility methods)
    
    _opposite: function (side) {
      return side == 'left' ? 'right' : 'left'
    }
    
  };

  /*******************************/
  /* wrapping it all in a plugin */
  /*******************************/

  $.fn.wysihtml5ImgResizer = function (method) {
    if (wysihtml5ImgResizer.publicMethods[method]) {
      return wysihtml5ImgResizer.publicMethods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || !method) {
      return wysihtml5ImgResizer.publicMethods.initialize.apply(this, arguments);
    } else {
      $.error('Method ' + method + ' does not exist on jQuery.wysihtml5ImgResizer');
    }
  };

})($);