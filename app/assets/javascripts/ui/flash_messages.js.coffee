SG.UI.FlashMessages =

  initialize: ->
    @initFlashEvents()
    @initAjaxFlash()
    @initFlashHide()
    @attachFlashClose()

  initFlashEvents: ->
    $(document).on 'webkitAnimationEnd mozAnimationEnd oAnimationEnd animationEnd', '.rails-flash', (e) ->
      $(e.target).remove() if $(e.target).hasClass('fadeOutDown')
    $(document).on 'append', '#flash_tray ul', (e) =>
      @initFlashHide @jsFlashEls().first()

  initAjaxFlash: ->
    $(document).on 'ajaxComplete', (e, request) =>
      msg = request.getResponseHeader("X-Message")
      msgType = request.getResponseHeader("X-Message-Type")
      msgTitle = request.getResponseHeader("X-Message-Title") || msgType
      @showFlash(msg, msgType, msgTitle) if msg?

  initFlashHide: (el) ->
    $el = el && $(el) || @flashEls().first()
    setTimeout (=> @hideFlash($el)), 10000

  hideFlash: ($el) ->
    $el.addClass('fadeOutDown')

  showFlash: (msg, msgType, msgTitle) ->
    flash = @buildFlash(msg, msgType, msgTitle)
    @flashContainerEl().append(flash)

  attachFlashClose: ->
    @flashContainerEl().on 'click', '.messenger-close', (e) =>
      @hideFlash $(e.target).parents('.rails-flash')

  buildFlash: (msg, msgType, msgTitle) ->
    JST['shared/flash'](msg: msg, msgType: msgType, msgTitle: msgTitle)

  jsFlashEls: -> @flashContainerEl().find('.js-flash')

  flashEls: -> @flashContainerEl().find('.rails-flash')

  flashContainerEl: -> $('#flash_tray ul')
