SG.UI.FlashMessages =

  initialize: ->
    @attachFlashClose()

  showFlash: (messageType, header, content) ->
    flash = @buildFlash(messageType, header, content)
    @flashMessagesEl().append(flash).show()
    @attachFlashClose()

  buildFlash: (messageType, header, content) ->
    $("<div class='ui message #{messageType}'><i class='close icon'></i><div class='header'>#{header}</div><p>#{content}</p></div>")

  attachFlashClose: ->
    @flashMessagesEl().find('.close.icon').on 'click', (e) => @closeFlash(e)

  closeFlash: (event) ->
    @flashMessagesEl().find(event.target).parents('.ui.message').remove()

  flashMessagesEl: -> $('#flash_messages')
