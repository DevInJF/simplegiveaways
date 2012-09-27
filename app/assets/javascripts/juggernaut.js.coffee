jQuery ->

  _sg = simpleGiveaways

  hasLoginParam = () ->
    _sg.utils.getURLParameter("login") is "true"

  hasntRefreshed = () ->
    document.cookie.indexOf("_sg-just_logged_in") is -1

  if hasLoginParam() and hasntRefreshed()

    document.cookie = "_sg-just_logged_in=1"

    jug_data = null
    $markup = null
    $menu_item = null
    pid = null
    $pid_el = null
    $menu_el = null

    jug = new Juggernaut(
      secure: false,
      host: "node.simplegiveaways.com",
      port: 80,
      transports: ['xhr-polling', 'jsonp-polling']
    )
    stale_count = $(".facebook_page_preview").length
    fresh_count = null

    onReceipt = (jug_data)->
      $markup = $(jug_data.markup)
      $menu_item = $(jug_data.menu_item)
      pid = $markup.data("fb-pid")
      $pid_el = $("[data-fb-pid=" + pid + "]")
      $menu_el = $("header.site .dropdown-menu.pages")

      $(".loader").slideUp().hide()

      if $pid_el.length
        $pid_el.replaceWith($markup)
      else
        $(".tab-content .container").append($markup)

      if $menu_el.find("li[data-fb-pid='" + pid + "']").length
        $menu_el.find("li[data-fb-pid='" + pid + "']").replaceWith($menu_item)
      else
        $menu_el.append($menu_item)

      $markup.find(".dynamo").dynamo()

    onLastReceipt = ->
      previous_dynamo = $(".pane_heading h2 .dynamo").text()
      fresh_count = $(".facebook_page_preview").length
      new_markup = '<span class="dynamo count" data-lines="' + fresh_count + '">' + stale_count + '</span>'

      $(".pane_heading h2 .dynamo").replaceWith(new_markup)
      $(".page_subtitle .dynamo").replaceWith(new_markup)
      $(".dynamo.count").dynamo()

      jug.unsubscribe("users#show_#{_sg.csrf()}")

    jug.subscribe("users#show_#{_sg.csrf()}", (jug_data) ->

      jug_data = JSON.parse(jug_data)

      onReceipt(jug_data)
      onLastReceipt() if jug_data.is_last is "true"

      jug.on "disconnect", ->
        jug.unsubscribe("users#show_#{_sg.csrf()}")

    key: "#{_sg.csrf()}")