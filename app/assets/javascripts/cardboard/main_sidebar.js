$(function(){
  $("a#nav_dashboard_link").click(function(e){
    e.preventDefault();
    $(".content-sidebar").toggleClass('toggle');

    // Expand .main-content down to fit the exposed sidebar
    $(".main-content").css('height',
      $('.content-sidebar').height() + $('.main-topbar').height()
    );

    $('#content').toggleClass('toggle');
    // $(this).toggleClass('active');
  });


  // Filter page sidebar
  $('#sidebar_page_search').search('.page_link', function(on) {
    on.all(function(results) {
      var size = results ? results.size() : 0
    });

    on.reset(function() {
      $('#sidebar_page_search_none').hide();
      $('.page_link').show();
    });

    on.empty(function() {
      $('#sidebar_page_search_none').show();
      $('.page_link').hide();
    });

    on.results(function(results) {
      $('#sidebar_page_search_none').hide();
      $('.page_link').hide();
      results.show();
    });
  });
});
