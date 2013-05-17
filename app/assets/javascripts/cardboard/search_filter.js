$(function(){
  
  var $advanced_field_select = $("select#advanced_field");
  var $ransack_select = $("select#ransack_options")
  var $ransack_options = $("select#ransack_options").html();

  $advanced_field_select.change(function(){
    var type = $advanced_field_select.find(":selected").data("type");
    var options = $($ransack_options).filter("optgroup[label='" + type + "']").html()
    $ransack_select.html(options);
    $ransack_select.trigger("change");
  });
  $advanced_field_select.trigger("change");

  $ransack_select.change(function(){
    var field_name = $advanced_field_select.find(":selected").val() +"_" + $(this).val();
    $("#advanced_query").attr("name", "q["+field_name+"]").val("");
  });
  $("#advanced_search_link").click(function(){
    $("#simple_search").hide();
    $("#advanced_search").show();
  });
  $("#simple_search_link").click(function(){
    $("#advanced_search").hide();
    $("#simple_search").show();
  });
});