$ ->
  ransack_options = undefined
  $(document).on 'page:load ready', (e) ->
    ransack_options = $('select#ransack_options').html()
    $('select#advanced_field').trigger 'change'
    return
  $(document).on 'change', 'select#advanced_field', ->
    type = $(@).find(':selected').data('type')
    options = $(ransack_options).filter('optgroup[label=\'' + type + '\']').html()
    $('select#ransack_options').html(options).trigger 'change'
    $('select#ransack_options').selectpicker 'refresh'
    return
  $(document).on 'change', 'select#ransack_options', ->
    field_name = $('select#advanced_field').find(':selected').val() + '_' + $(@).val()
    $('#advanced_query').attr('name', 'q[' + field_name + ']').val ''
    return
  $(document).on 'click', '#advanced_search_link', ->
    $('#simple_search').hide()
    $('#advanced_search').show()
    return
  $(document).on 'click', '#simple_search_link', ->
    $('#advanced_search').hide()
    $('#simple_search').show()
    return
  return
