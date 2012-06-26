var jug = new Juggernaut;
jug.subscribe("users#show", function(fb_page_markup){
  var $markup = $(fb_page_markup),
          pid = $markup.data("fb-pid");

  $("[data-fb-pid=" + pid + "]").replaceWith($markup);
  $markup.find(".dynamo").dynamo();
});