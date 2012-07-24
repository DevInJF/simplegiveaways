jQuery ->

  _sg = simpleGiveaways

  loggedIn = _sg.current_user.name?

  fbAuthStatusChange = (response) ->
    authorizeUser(response) if response? and loggedIn?

  authorizeUser = (response) ->
    readableStatus = response.status in ["unknown", "not_authorized", "connected"]

    doRedirect() if readableStatus and shouldRedirect(response)

  shouldRedirect = (response) ->
    return true unless response.authResponse?
    response.authResponse.userID isnt _sg.current_user.fb_uid

  doRedirect = ->
    window.location.href = "/logout?fb=true"

  $(document).on 'fb:initialized', ->
    FB.getLoginStatus(fbAuthStatusChange)

  $(document).fb _sg.config.fb_app_id