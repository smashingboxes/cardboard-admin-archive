$(document).ready ->
  updateURL = $('#content_pages').attr('data-update-url')
  sortableSettings = 
    axis: 'y'
    handle: '.sort_handle'
    update: postRefresh

  postRefresh = (event, ui) ->
    content = ui.item.html()
    # post results to server and save effect
    $.post(updateURL,
      id: ui.item.attr('id').replace('pages_', '')
      index: ui.item.index()).done ->
      $(ui.item).html '<div class="link_wrap"><a href="#" class="offset-0 saving">Saved!</a></div>'
      setTimeout (->
        $(ui.item).html content
        $('#content_pages, .page_group').sortable sortableSettings
        return
      ), 800
      return
    return

  $('#content_pages, .page_group').sortable sortableSettings
  return

  
