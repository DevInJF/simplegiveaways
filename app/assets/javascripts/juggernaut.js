var jug = new Juggernaut;

jug.subscribe("users#show", function(jug_data){

  var jug_data = JSON.parse(jug_data),
       $markup = $(jug_data.markup),
           pid = $markup.data("fb-pid"),
       $pid_el = $("[data-fb-pid=" + pid + "]");

  if ( $pid_el.length ) {
    $pid_el.replaceWith($markup);
  } else {
    $(".tab-content .container").append($markup);
  }

  $markup.find(".dynamo").dynamo();

  if (jug_data.is_last == "true") {

    var previous_dynamo = $(".pane_heading h2 .dynamo").text();
    var new_dynamo = $(".facebook_page_preview").length;
    var new_markup = "<span class='dynamo count' data-lines='" + new_dynamo + "'>" + previous_dynamo + "</span>";

    $(".pane_heading h2 .dynamo").replaceWith(new_markup);
    $(".page_subtitle .dynamo").replaceWith(new_markup);
    $(".dynamo.count").dynamo();
    jug.unsubscribe("users#show");
  }
});