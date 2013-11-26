SG.UI =

  initialize: ->
    @initDropdowns()
    @initCheckboxes()
    @initAccordions()

  initDropdowns: ->
    $('.ui.dropdown').dropdown() if $('.ui.dropdown').length

  initCheckboxes: ->
    $('.ui.checkbox').checkbox() if $('.ui.checkbox').length

  initAccordions: ->
    $('.ui.accordion').accordion() if $('.ui.accordion').length

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
