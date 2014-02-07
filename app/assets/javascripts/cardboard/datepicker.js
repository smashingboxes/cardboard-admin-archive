var create_datepickers = function(){

  $('input.datepicker').datepicker({format: 'yyyy-mm-dd'}).on('changeDate', function() {
    $(this).data('datepicker').hide();
  });

  // $('input.datetimepicker').datepicker({format: "yyyy-mm-dd HH:mm pp", pick12HourFormat: true}).on('changeDate', function() {
  //   $(this).data('datepicker').hide();
  // });
}


$(document).on("ready pjax:success", function () {
  create_datepickers();

  $(document).on('cocoon:after-insert', function(e, insertedItem) {
    create_datepickers();
  });
});
