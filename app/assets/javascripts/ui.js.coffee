SG.UI =

  initialize: ->
    @initDropdowns()
    @initCheckboxes()
    @initAccordions()
    @initDateTimePickers()

  initDropdowns: ->
    $('.ui.dropdown').dropdown() if @dropdownEls().length

  initCheckboxes: ->
    $('.ui.checkbox').checkbox() if @checkboxEls().length

  initAccordions: ->
    $('.ui.accordion').accordion() if @accordionEls().length

  initDateTimePickers: ->
    @attachFilthyPillow(el) for el in @dateTimePickerEls()

  attachFilthyPillow: (el) ->
    $el = $(el)

    initial = moment($(el).val()) || moment().add('minutes', 10)
    minDate = initial || moment()

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

  dateTimePickerEls: -> $('.datetime-picker')
