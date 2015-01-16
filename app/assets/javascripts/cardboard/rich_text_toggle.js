$(document).on("page:update", function() {
  $(".btn.btn-default[name='commit']").click(function() {
    var html5 = $(".wysiwyg.wysihtml5").val();
    var markdown = $("[name*='markdown']").val();
    // have to figure out how to modify params at this point
  });
});
