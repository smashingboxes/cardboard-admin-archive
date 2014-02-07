$(document).on('click', 'form#template .remove_fields', function(event) {
  $(this).prev('input[type=hidden]').val('1');
  $(this).closest('fieldset').hide();
  event.preventDefault();
)}

$(document).on('click', 'form#template .add_fields', function(event) {
  time = new Date().getTime();
  regexp = new RegExp($(this).data('id'), 'g');
  $(this).before($(this).data('fields').replace(regexp, time));
  event.preventDefault();
)}

$(document).on('click', 'form#template .remove_parts', function(event) {
  $(this).prev('input[type=hidden]').val('1');
  $(this).closest('fieldset').hide();
  event.preventDefault();
)}

$(document).on('click', 'form#template .add_parts', function(event) {
  time = new Date().getTime();
  regexp = new RegExp($(this).data('id'), 'g');
  $(this).before($(this).data('parts').replace(regexp, time));
  event.preventDefault();
)}