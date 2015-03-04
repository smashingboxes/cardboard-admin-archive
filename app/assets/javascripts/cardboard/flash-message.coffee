$(document).on 'ready page:load cocoon:after-insert', ->
  $(".alert .close").click ->
    $(@).parent().slideUp().fadeOut()
