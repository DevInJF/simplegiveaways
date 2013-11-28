SG.UI.DatetimePickers =

  initialize: ->
    @attachFilthyPillow(el) for el in @dateTimePickerEls()

  attachFilthyPillow: (el) ->
    $el = $(el)

    if $(el).val().length
      initial = moment($(el).val())
    else
      initial = moment().add('minutes', 10)

    $el.filthypillow
      initialDateTime: -> initial
      minDateTime: -> moment()

    $el.on 'focus', -> $el.filthypillow 'show'

    $el.on 'fp:save', (e, dateObj) ->
      $el.val dateObj.format 'MMM DD YYYY hh:mm A'
      $el.filthypillow 'hide'

  dateTimePickerEls: -> $('.datetime-picker')
