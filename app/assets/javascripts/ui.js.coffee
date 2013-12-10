SG.UI =

  initialize: ->
    SG.UI.ZClip.initialize()
    SG.UI.DatetimePickers.initialize()
    SG.UI.FlashMessages.initialize()
    @initDropdowns()
    @initCheckboxes()
    @initAccordions()
    @initPopups()

  initDropdowns: ->
    @dropdownEls().dropdown(debug: false) if @dropdownEls().length

  initCheckboxes: ->
    @checkboxEls().checkbox(debug: false) if @checkboxEls().length

  initAccordions: ->
    @accordionEls().accordion(debug: false) if @accordionEls().length

  initPopups: ->
    @initPopup(el) for el in @popupEls()

  initPopup: (el) ->
    $(el).popup
      debug: false
      on: $(el).data('on')

  dropdownEls: -> $('.ui.dropdown')

  checkboxEls: -> $('.ui.checkbox').not('.radio')

  accordionEls: -> $('.ui.accordion')

  popupEls: -> $('.popup-trigger')
