$(document).ready(function(){
  
  $('#content_pages, .page_group').sortable({
    axis: "y",
    handle: ".sort_handle"
  });

  $('.page_link').hover(function(){
    $(this).find('.sort_handle').show();
  }, function(){
    $(this).find('.sort_handle').hide();
  });

});