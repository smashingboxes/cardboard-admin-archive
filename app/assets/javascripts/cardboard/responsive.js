var switchMenuSmall = function() {
  $('#cardboard_logo').replaceWith('<a id="cardboard_logo"><i class="fa fa-reorder" /></a>');
};

var switchMenuLarge = function() {
  $('#cardboard_logo').replaceWith('<div id="cardboard_logo">CB</div>');
};

var toggleMenu = function() {
  var $sidebar = $('#main_sidebar'),
    $content = $('#content');

  if($sidebar.hasClass('open')) {
      $sidebar.toggleClass('open');
      $(this).toggleClass('open');
      $content.toggleClass('open');
    }

    $('#cardboard_logo').on('click', function(e){
      e.preventDefault();
      $sidebar.toggleClass('open');
      $(this).toggleClass('open');
      $content.toggleClass('open');
    });
}

var removeSidebarMargin = function(){
  if($('#content_sidebar').is(":visible")) {
    $('.container-fluid').removeClass('toggle');
    $('#content_sidebar').addClass('responsive');
  }
}

var addSidebarMargin = function(){
  if($('#content_sidebar').is(":visible")) {
    $('.container-fluid').addClass('toggle');
    $('#content_sidebar').removeClass('responsive')

  }
}

var detectSize = function(){
  var windowsize = $(window).width()
  if(windowsize <= 768) {
    switchMenuSmall();
    toggleMenu();
    removeSidebarMargin();
  } else {
    switchMenuLarge();
    addSidebarMargin();
  }
};

$(window).resize(_.debounce(detectSize, 50));
$(document).on("page:load ready", function() {
  detectSize();
  $("#menu a").click(function () {
    detectSize();
  });
});
