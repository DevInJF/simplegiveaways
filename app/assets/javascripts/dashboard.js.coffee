SG.Dashboard =

  _sg: _SG

  initialize: ->
    @initPagesPoller() if @pagesPollerEl().length

  initPagesPoller: ->
    @pollTimer = setInterval (=> @pollPages()), 2250

  pollPages: ->
    $.ajax
      url: @_sg.Paths.userPages
      dataType: 'json'
      data: "pids=#{@getPids()}&bust=#{new Date().getTime()}"
      success: (response, status) =>
        if response.complete
          clearInterval(@pollTimer)
          @pagesTargetEl().data('pids', response.pids)
        else if response.pids
          @pagesTargetEl().data('pids', response.pids)
        @pagesTargetEl().append(response.html) if response.html.length

  getPids: ->
    @pagesTargetEl().data('pids')

  pagesTargetEl: -> $('#user_facebook_pages')

  pagesPollerEl: -> $('#pages_poller')
