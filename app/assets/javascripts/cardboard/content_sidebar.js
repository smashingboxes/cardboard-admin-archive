$(document).ready(function(){
  
  var updateURL = $('#content_pages').attr('data-update-url');
  
  $('#content_pages, .page_group').sortable({
    axis: "y",
    handle: ".sort_handle",
    update: function () {
      $.post(updateURL, $(this).sortable('serialize', {key: "pages[]"}));
    }
  });
});