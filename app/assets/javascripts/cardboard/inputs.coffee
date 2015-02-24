$(document).on 'ready page:load cocoon:after-insert', ->
  $('select').select2()

  $.each $('textarea'), (index, item) ->
    console.log $(@).attr("maxlength")
