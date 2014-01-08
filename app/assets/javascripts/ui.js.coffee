SG.UI =

  initialize: ->
    SG.UI.FlashMessages.initialize()
    @initDropdowns()
    @initCheckboxes()
    @initAccordions()
    @initPopups()
    @initReadmores()
    @initAutosize()
    SG.UI.ZClip.initialize()
    SG.UI.DatetimePickers.initialize()
    SG.UI.Editables.initialize()

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

  initAutosize: ->
    $('textarea').autosize()

  initReadmores: ->
    @initReadmore(el) for el in @readmoreEls()

  initReadmore: (el) ->
    $(el).jTruncate()

  dropdownEls: -> $('.ui.dropdown')

  checkboxEls: -> $('.ui.checkbox').not('.radio')

  accordionEls: -> $('.ui.accordion')

  popupEls: -> $('.popup-trigger')

  readmoreEls: -> $('.readmore')
