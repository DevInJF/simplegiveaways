var jug = new Juggernaut;
jug.subscribe("users#show", function(fb_page_markup){
  var pid = $(fb_page_markup).data("fb-pid");
  $("[data-fb-pid=" + pid + "]").replaceWith(fb_page_markup);
});