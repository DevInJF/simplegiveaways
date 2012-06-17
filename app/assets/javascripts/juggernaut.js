var jug = new Juggernaut;
jug.subscribe("users#show", function(fb_page_markup){
  console.log(fb_page_markup);
  $("body.show.users").find(".tab-content .container").prepend(fb_page_markup);
});