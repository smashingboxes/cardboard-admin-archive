$(document).on 'ready page:load cocoon:after-insert', ->
  $('select').select2()

  $.each $('textarea'), (index, item) ->
    console.log $(@).attr("maxlength")

  $.each $('input:checkbox'), (index, item) ->
    
    $(item).on 'change', ->
      me = $(@)

      if me.is ":checked"
        me.parent().addClass "selected"
      else
        me.parent().removeClass "selected"
        
