SG.UI =

  initialize: ->
    @initDropdowns()
    @initCheckboxes()
    @initAccordions()
    @initPopups()
    @initDateTimePickers()

  initDropdowns: ->
    @dropdownEls().dropdown(debug: false) if @dropdownEls().length

  initCheckboxes: ->
    @checkboxEls().checkbox(debug: false) if @checkboxEls().length

  initAccordions: ->
    @accordionEls().accordion(debug: false) if @accordionEls().length

  initPopups: ->
    @popupEls().popup
      debug: false
      title: $(this).data('title')
      content: $(this).data('content')

  initDateTimePickers: ->
    @attachFilthyPillow(el) for el in @dateTimePickerEls()

  attachFilthyPillow: (el) ->
    $el = $(el)

    if $(el).val().length
      initial = moment($(el).val())
      minDate = initial
    else
      initial = moment().add('minutes', 10)
      minDate = moment()

    $el.filthypillow
      initialDateTime: -> initial
      minDateTime: -> minDate

    $el.on 'focus', ->
      $el.filthypillow 'show'

    $el.on 'fp:save', (e, dateObj) ->
      $el.val dateObj.format('MMM DD YYYY hh:mm A')
      $el.filthypillow 'hide'

  dropdownEls: -> $('.ui.dropdown')

  checkboxEls: -> $('.ui.checkbox')

  accordionEls: -> $('.ui.accordion')

  popupEls: -> $('.popup-trigger')

  dateTimePickerEls: -> $('.datetime-picker')
