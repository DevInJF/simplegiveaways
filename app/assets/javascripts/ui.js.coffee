SG.UI =

  initialize: ->
    @initDropdowns()
    @initCheckboxes()

  initDropdowns: ->
    $('.ui.dropdown').dropdown() if $('.ui.dropdown').length

  initCheckboxes: ->
    $('.ui.checkbox').checkbox() if $('.ui.checkbox').length
