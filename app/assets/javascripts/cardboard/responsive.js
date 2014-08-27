var switchMenuSmall = function() {
  $('#cardboard_logo').replaceWith('<a href="#menu" id="cardboard_logo"><i class="icon-reorder" /></a>');
};

var switchMenuLarge = function() {
  $('#cardboard_logo').replaceWith('<div id="cardboard_logo">CB</div>');
};

var detectSize = function(){
  var windowsize = $(window).width(),
      sidebar = $('#main_sidebar'),
      content = $('#content');
  if(windowsize < 768) {
    switchMenuSmall();
    if(sidebar.hasClass('open')) {
      sidebar.toggleClass('open');
      $(this).toggleClass('open');
      content.toggleClass('open');
    }

    $('#cardboard_logo').on('click', function(){
      sidebar.toggleClass('open');
      $(this).toggleClass('open');
      content.toggleClass('open');
    }, function(e) {
      e.preventDefault();
      sidebar.toggleClass('open');
      $(this).toggleClass('open');
      content.toggleClass('open');
    });
  } else {
    switchMenuLarge();
  }
};

$(window).resize(detectSize);
$(document).on("page:load ready", detectSize);
