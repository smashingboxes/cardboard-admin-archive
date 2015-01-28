$(document).on("ready page:load", function() {
  $("a").click(function() {
    var link_root = this.href.split('/')[3];
    var document_root = document.location.href.split('/')[3];
    if (typeof link_root != 'undefined' && link_root !== document_root) {
      window.open(this.href, '_blank');
      return(false);
    }
  });
});
