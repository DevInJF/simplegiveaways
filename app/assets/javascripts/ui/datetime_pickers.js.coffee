SG.UI.DatetimePickers =

  initialize: ->
    @attachDatetimePicker(el) for el in @dateTimePickerEls()

  attachDatetimePicker: (el) ->
    $el = $(el)

    if $(el).val().length
      initial = moment($(el).val())
    else
      initial = moment().add('minutes', 10)

    $el.datetimepicker
      step: 15
      format: "l, F d, Y @ h:i A"
      formatDate: "m/d/Y"
      formatTime: "h:i A"
      minDate: "#{moment().add('minutes', 10).format('M/D/YYYY')}"
      onChangeDateTime: (current, $input) =>
        @conflictContainerEl($input).find('.conflict').empty()
        @checkSchedule(current, $input)

  checkSchedule: (datetime, input) ->
    $.ajax
      url: SG.Paths.checkSchedule
      dataType: 'json',
      data:
        facebook_page_id: SG.currentPageId
        start_date: datetime
      success: (conflicts, status) =>
        if conflicts.length
          @showConflictMessage(input, conflict) for conflict in conflicts
        else
          @conflictContainerEl(input).hide()

  showConflictMessage: (input, conflict) ->
    @conflictContainerEl(input).show().append("<div class='conflict'><strong>#{conflict.title}</strong><br />#{moment(conflict.start_date).format('M/D/YYYY')} - #{moment(conflict.end_date).format('M/D/YYYY')}</div>")

  conflictContainerEl: (input) ->
    $(input).parents('.date-container').children('.conflicts-container')

  dateTimePickerEls: -> $('.datetime-picker')
