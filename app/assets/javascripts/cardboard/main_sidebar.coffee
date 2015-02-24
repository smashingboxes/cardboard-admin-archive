$(document).on 'ready page:load cocoon:after-insert', ->
  # $('a#nav_dashboard_link').click (e) ->
  #   e.preventDefault()
  #   $('.content-sidebar').toggleClass 'toggle'
  #   # Expand .main-content down to fit the exposed sidebar
  #   $('.main-content').css 'height', $('.content-sidebar').height() + $('.main-topbar').height()
  #   $('#content').toggleClass 'toggle'
  #   # $(this).toggleClass('active');
  #   return
  # Filter page sidebar
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
