SG.Users =

  initialize: ->
    @initPagesPoller() if @pagesPollerEl().length

  initPagesPoller: ->
    @pollTimer = setInterval (=> @pollPages()), 2500

  pollPages: ->
    $.ajax
      url: SG.Paths.userPages
      dataType: 'json',
      success: (response, status) =>
        @pagesTargetEl().html(response.html) if response.html.length
        if response.complete
          @pagesPollerEl().transition(complete: => @pagesPollerEl().remove())
          clearInterval(@pollTimer)

  pagesTargetEl: -> $('#user_facebook_pages')

  pagesPollerEl: -> $('#pages_poller')
