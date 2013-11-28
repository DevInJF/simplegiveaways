SG.UI =

  initialize: ->
    SG.UI.ZClip.initialize()
    SG.UI.DatetimePickers.initialize()
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
    if @popupEls().length
      @popupEls().popup
        debug: false
        title: $(this).data('title')
        content: $(this).data('content')

  dropdownEls: -> $('.ui.dropdown')

  checkboxEls: -> $('.ui.checkbox')

  accordionEls: -> $('.ui.accordion')

  popupEls: -> $('.popup-trigger')
