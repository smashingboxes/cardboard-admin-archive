$(document).on("page:load ready", function() {
  $("a").click(function() {
    var link_host = this.href.split('/')[3];
    var document_host = document.location.href.split('/')[3];
    if (link_host != document_host) {
      window.open(this.href, '_blank');
      return(false);
    }
  });
});
