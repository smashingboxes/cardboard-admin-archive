$(document).ready(function(){
  
  var updateURL = $('#content_pages').attr('data-update-url');
  
  var sortableSettings = {
    axis: "y",
    handle: ".sort_handle",
    update: postRefresh
  }
  
  $('#content_pages, .page_group').sortable(sortableSettings);
  
  function postRefresh(event, ui) {
    var content = $(ui.item).html();
    
    // post results to server and save effect
    $.post(updateURL, $(this).sortable('serialize', {key: "pages[]"}))
      .done(function() {
        $(ui.item).html('<div class="link_wrap"><a href="#" class="offset-0 saving">Saved!</a></div>');
        setTimeout(function(){
          $(ui.item).html(content);
          $('#content_pages, .page_group').sortable(sortableSettings);
        }, 800);
      });
  }
  
});