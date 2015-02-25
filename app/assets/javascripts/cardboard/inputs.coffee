$(document).on 'ready page:load cocoon:after-insert', ->
  $('select').select2()

  $.each $('textarea'), (index, item) ->
    console.log $(@).attr("maxlength")

  $.each $(':checkbox'), (index, item) ->
    
    $(item).change ->

      me = $(@)

      if me.is ":checked"
        me.parent().addClass "selected"
      else
        me.parent().removeClass "selected"
      

  $.each $(':radio'), (index, item) ->
    
    $(item).change ->
      
      me = $(@)

      $(":radio[name= '#{me.attr 'name'}']").parent().removeClass "selected"

      me.parent().addClass "selected"

  $.each $('.datepicker'), (index, item) ->
    $(item).datepicker({
      showOtherMonths: true
    })
