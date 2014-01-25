SG.UI.FlashMessages =

  initialize: ->
    @initAjaxFlash()
    @initFlashHide()
    @attachFlashClose()

  initAjaxFlash: ->
    $(document).ajaxComplete (event, request) =>
      msg = request.getResponseHeader("X-Message")
      msgType = request.getResponseHeader("X-Message-Type")
      msgTitle = request.getResponseHeader("X-Message-Title")
      @showFlash(msg, msgType, msgTitle) if msg?

  initFlashHide: (el) ->
    $el = el && $(el) || @flashEls().first()
    setTimeout (=> @hideFlash($el)), 7500

  hideFlash: ($el) ->
    $el.addClass('fadeOutDown')

  showFlash: (messageType, header, content) ->
    flash = @buildFlash(messageType, header, content)
    @flashContainerEl().append(flash)
    @initFlashHide(flash)

  attachFlashClose: ->
    @flashContainerEl().on 'click', '.messenger-close', (e) =>
      @hideFlash $(e.target).parents('.rails-flash')

  buildFlash: (msg, msgType, msgTitle) ->
    $("<li class='rails-flash messenger-message-slot animated fadeInUp'><div class='alert-#{msgType} message message-#{msgType} messenger-message'><div class='messenger-message-inner'><span class='message-icon'><i class='bg-#{msgType} fa fa-bell-o time-icon'></i></span><div class='message-text'><h4>#{msgTitle || msgType}</h4><p>#{msg}</p></div><button class='messenger-close' data-dismiss='alert' type='button'>×</button></div><div class='messenger-spinner'><span class='messenger-spinner-side messenger-spinner-side-left'><span class='messenger-spinner-fill'></span></span><span class='messenger-spinner-side messenger-spinner-side-right'><span class='messenger-spinner-fill'></span></span></div></div></li>")

  flashEls: -> @flashContainerEl().find('.rails-flash')

  flashContainerEl: -> $('#flash_tray ul')
