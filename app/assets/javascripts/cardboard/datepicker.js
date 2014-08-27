var create_datepickers = function(){

  $('input.datepicker, input[id$="_on"], input[id$="_at"').datepicker({format: 'yyyy-mm-dd'}).on('changeDate', function() {
    $(this).data('datepicker').hide();
  });

  // $('input.datetimepicker').datepicker({format: "yyyy-mm-dd HH:mm pp", pick12HourFormat: true}).on('changeDate', function() {
  //   $(this).data('datepicker').hide();
  // });
}


$(document).on("ready page:load cocoon:after-insert", function () {
  create_datepickers();
});
