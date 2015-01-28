$(document).on("ready page:load", function() {
  $(".preview-link").on('click', function(){
    var markdown_content = $("#markdown-body").val();
    if (markdown_content === '') {
      $(".markdown-preview").text("Nothing to preview");
    }
    else {
      $.post("/cardboard/markdown",
      { markdown: markdown_content },
      function(result) {
        $(".markdown-preview").html(result);
      });
    }
  });
});
