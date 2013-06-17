$(function(){
  $("a#nav_dashboard_link").click(function(e){
    e.preventDefault();
    $("#content_sidebar").toggleClass('toggle');
    $('#content').toggleClass('toggle');
    // $(this).toggleClass('active');
  });


  // Filter page sidebar
  $('#sidebar_page_search').search('.page', function(on) {
    on.all(function(results) {
      var size = results ? results.size() : 0
    });

    on.reset(function() {
      $('#sidebar_page_search_none').hide();
      $('.page').show();
    });

    on.empty(function() {
      $('#sidebar_page_search_none').show();
      $('.page').hide();
    });

    on.results(function(results) {
      $('#sidebar_page_search_none').hide();
      $('.page').hide();
      results.show();
    });
  });
});