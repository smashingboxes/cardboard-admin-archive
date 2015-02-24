$(document).on 'ready page:load cocoon:after-insert', ->
  $(".menu-toggle").click ->
    $(".body__container").toggleClass "open"

