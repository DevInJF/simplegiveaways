jQuery ->

  _sg = simpleGiveaways

  giveaway_hash = _sg.giveaway_hash.table
  giveaway_object = giveaway_hash.giveaway.table
  paths = _sg.paths

  $authed = null
  $email = null
  $new_session = null
  $entry_id = null
  $request_count = null
  $wall_post_count = null
  $just_liked = false
  $referrer_id = "#{giveaway_hash.referrer_id}" or ""
  $modal = $("#giveaway_modal")
  $form = $modal.find(".form")
  $form_submit = $form.find("a.btn.btn-primary.submit")
  $auth = $modal.find(".auth")
  $auth_button = $auth.find("a.btn.btn-primary.auth")
  $loader = $modal.find(".loader")

  $auth_required = () ->
    giveaway_object.auth_required == "true"
  $autoshow = () ->
    giveaway_object.autoshow_share == "true"

  $("#giveaway_image").click ->
    Giveaway.modal.hide()

  fb_init_options =
    status: true
    cookie: true
    xfbml: true
    channelUrl: 'http://simplegiveaways.com/channel.html'

  $(document).fb _sg.config.fb_app_id, fb_init_options

  $(document).on 'fb:initialized', ->

    if $auth_required()
      FB.getLoginStatus (response) ->
        Giveaway.init()
    else
      Giveaway.init()

  Giveaway =

    init: ->
      FB.Canvas.setSize height: "#{giveaway_hash.tab_height}"

      FB.Event.subscribe 'edge.create', (href, widget) ->
        $just_liked = true
        Giveaway.step.one.hide()
        Giveaway.step.two.show()
        Giveaway.onLike()

      $("#enter_giveaway a").live "click", (e) ->
        if Giveaway.eligible() or $just_liked
          Giveaway.entry.eligible()
        else
          Giveaway.modal.show()
          Giveaway.step.one.show()
        e.preventDefault()

      Giveaway.step.two.find("a").live "click", (e) ->
        e.preventDefault()
        Giveaway.entry.statusCheck()

      Giveaway.termsLink()

    modal: $modal

    step:
      one: $modal.find(".step.one")
      two: $modal.find(".step.two")
      three: $modal.find(".step.three")

    loader: $loader

    termsLink: ->
      $("a.terms-link.terms-text").click (e) ->
        $(".terms-text.hidden").show()
        FB.Canvas.setSize(height: ($("#tab_container").height() + 40))
        e.preventDefault()

    eligible: ->
      "#{giveaway_hash.has_liked}" == "true"

    onLike: ->
      $.ajax
        type: "POST"
        url: "#{paths.likes}"
        dataType: "json"
        data: "like[giveaway_id]=#{giveaway_object.id}"
        success: (data, textStatus, jqXHR) ->
          return true

    entry:

      loader: ->
        $modal.find(".step").hide()
        $loader.show()
        $modal.show()

      form: ->
        $loader.hide()
        $form.show()
        $form_submit.click (e) ->
          $email = $form.find("input").val()
          $new_session = "auth_disabled"
          Giveaway.entry.eligible()
          e.preventDefault()
        $(document).keypress (e) ->
          if (e.which == 13) && $form.is(':visible')
            $form_submit.click()

      error: (error) ->
        $loader.hide()
        $form.hide()
        $auth.hide()
        Giveaway.step.two.hide()
        Giveaway.step.three.show().find(".entry-status").html "<p>" + error + "</p>"
        Giveaway.share.listener()

      success: ->
        $loader.hide()
        $form.hide()
        $auth.hide()
        Giveaway.step.two.hide()
        Giveaway.step.three.show()
        Giveaway.share.listener()
        if $autoshow()
          $("a.app-request").click()

      submit: (access_token, json) ->
        Giveaway.entry.loader()
        if json?
          access_token = eval("(" + access_token + ")")
        $.ajax
          type: "POST"
          url: "#{paths.giveaway_entry}"
          dataType: "json"
          data: "access_token=" + access_token + "&has_liked=" + Giveaway.eligible() + "&ref_id=" + $referrer_id + "&email=" + $email,
          statusCode:
            201: (response) ->
              $entry_id = response
              $wall_post_count = 0
              $request_count = 0
              Giveaway.entry.success()

            406: (response) ->
              Giveaway.entry.error "You have already entered the giveaway.<br />Entry is limited to one per person."
              $entry = jQuery.parseJSON(response.responseText)
              $entry_id = $entry.id
              $wall_post_count = parseInt($entry.wall_post_count)
              $request_count = parseInt($entry.request_count)

            412: ->
              $loader.hide()
              Giveaway.step.one.show()

            404: ->
              Giveaway.entry.error "There was an unexpected error.<br />Please reload the page and try again."

            424: ->
              Giveaway.entry.error "There was an unexpected error.<br />Please reload the page and try again."

      statusCheck: ->
        FB.getLoginStatus (response) ->
          if response.authResponse && response.authResponse.accessToken
            $new_session = response.authResponse.accessToken
            Giveaway.entry.eligible()
          else if $auth_required()
            Giveaway.entry.auth(response)
          else
            Giveaway.entry.form()

      eligible: ->
        Giveaway.entry.loader()
        if $new_session?
          Giveaway.entry.submit $new_session
        else
          Giveaway.entry.statusCheck()

      auth: (response) ->
        $loader.hide()
        $auth.show()
        $auth_button.click (e) ->
          FB.login (response) ->
            if response.authResponse && response.authResponse.accessToken
              $new_session = response.authResponse.accessToken
              Giveaway.entry.eligible()
            else
              Giveaway.modal.show()
              Giveaway.entry.error "You must grant permissions in order to enter the giveaway."
            $auth.hide()
          , scope: "email, user_location, user_birthday, user_likes, publish_stream, offline_access"
          e.preventDefault()

    share:
      listener: ->
        $("a.wall-post").click (e) ->
          Giveaway.share.as_wall_post()
          e.preventDefault()

        $("a.app-request").click (e) ->
          Giveaway.share.as_app_request()
          e.preventDefault()

      callback: (json) ->
        $.ajax
          type: "PUT"
          url: "#{paths.giveaway_entry}/#{$entry_id}"
          dataType: "text"
          data: json
          statusCode:
            202: ->

            406: ->

            404: ->
              Giveaway.entry.error "There was an unexpected error.<br />Please reload the page and try again."

      dialog: (data) ->
        FB.ui data, (response) ->
          if response and response.post_id
            json = entry:
              wall_post_count: $wall_post_count + 1
            Giveaway.share.callback json
          else if response and response.to
            json = entry:
              request_count: $request_count + response.to.length
            Giveaway.share.callback json
          else
            return true

      as_wall_post: ->
        Giveaway.share.dialog
          method: "feed"
          name: "#{giveaway_hash.current_page.name}"
          link: "#{giveaway_object.giveaway_url}" + "&app_data=ref_" + $entry_id
          picture: "#{giveaway_object.feed_image_url}"
          caption: "#{giveaway_object.title}"
          description: "#{giveaway_object.description}"

      as_app_request: ->
        Giveaway.share.dialog
          title: "Share this giveaway to receive a bonus entry."
          method: "apprequests"
          message: "#{giveaway_object.description}"
          data:
            referrer_id: $entry_id.toString()
            giveaway_id: "#{giveaway_object.id}"
