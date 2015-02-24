$(document).on 'ready page:load cocoon:after-insert', ->
  $('.sidebar_page_search').search '.page_link', (event) ->
    event.all (results) ->
      size = if results then results.size() else 0
      return
    event.reset ->
      $('.sidebar_page_search_none').hide()
      $('.page_link').show()
      return
    event.empty ->
      $('.sidebar_page_search_none').show()
      $('.page_link').hide()
      return
    event.results (results) ->
      $('.sidebar_page_search_none').hide()
      $('.page_link').hide()
      results.show()
      return
    return
  return
