$(document).on("page:update", function() {
  $(".preview-link").click(function(){
    var markdown_content = $("#markdown-body").val();
    if (markdown_content === '') {
      $(".markdown-preview").text("Nothing to preview");
    }
    else {
      $.post("/cardboard/render_markdown",
      { markdown: markdown_content },
      function(result) {
        $(".markdown-preview").html(result);
      });
    }
  });
});
