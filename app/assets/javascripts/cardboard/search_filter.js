$(function(){
   var ransack_options;
  
  $(document).on("pjax:end ready", function(e){
    ransack_options = $("select#ransack_options").html();
    $("select#advanced_field").trigger("change");
  })

  $(document).on('change', "select#advanced_field", function(){
    var type = $(this).find(":selected").data("type");
    var options = $(ransack_options).filter("optgroup[label='" + type + "']").html()
    $("select#ransack_options").html(options).trigger("change");
  });
  
  $(document).on('change',"select#ransack_options", function(){
    var field_name = $("select#advanced_field").find(":selected").val() +"_" + $(this).val();
    $("#advanced_query").attr("name", "q["+field_name+"]").val("");
  });
  $(document).on('click', "#advanced_search_link", function(){
    $("#simple_search").hide();
    $("#advanced_search").show();
  });
  $(document).on('click', "#simple_search_link", function(){
    $("#advanced_search").hide();
    $("#simple_search").show();
  });
});