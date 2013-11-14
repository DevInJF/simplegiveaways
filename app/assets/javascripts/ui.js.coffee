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

  showFlash: (messageType, content) ->
