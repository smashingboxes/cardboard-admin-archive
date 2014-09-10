var switchMenuSmall = function() {
  $('#cardboard_logo').replaceWith('<a id="cardboard_logo"><i class="icon-reorder" /></a>');
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

var detectSize = function(){
  var windowsize = $(window).width()
  if(windowsize <= 568) {
    switchMenuSmall();
    toggleMenu();
  } else {
    switchMenuLarge();
  }
};

$(window).resize(_.debounce(detectSize, 50));
$(document).on("page:load ready", function() {
  detectSize();
  $("#menu a").click(function () {
    detectSize();
  });
});
