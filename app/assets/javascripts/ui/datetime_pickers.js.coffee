SG.UI.DatetimePickers =

  _sg: _SG

  initialize: (el) ->
    if el?
      @attachDatetimePicker(el, true)
    else
      @attachDatetimePicker(el) for el in @dateTimePickerEls()

  attachDatetimePicker: (el, inline = false) ->
    $el = $(el)

    $el.datetimepicker
      step: 15
      format: "l, F d, Y @ h:i A"
      formatDate: "m/d/Y"
      formatTime: "h:i A"
      inline: inline
      minDate: @setMinDate($el)
      onChangeDateTime: (current, $input) =>
        unless @startConflicts && $input.data('date-type') == 'end'
          @conflictContainerEl($input).find('.conflict').remove()
          @checkSchedule(current, $input)
      onClose: =>
        SG.UI.DatetimePickers.initialize()
      validateOnBlur: false

  checkSchedule: (datetime, input) ->
    $.ajax
      url: @_sg.Paths.checkSchedule
      dataType: 'json',
      data:
        giveaway_id: @_sg.CurrentGiveaway.ID
        facebook_page_id: @_sg.CurrentPage.ID
        date: datetime
        date_type: $(input).data('date-type')
      success: (conflicts, status) =>
        if conflicts.length
          @startConflicts = true if $(input).data('date-type') == 'start'
          @showConflictMessage(input, conflict) for conflict in conflicts
        else
          @startConflicts = false if $(input).data('date-type') == 'start'
          @conflictContainerEl(input).hide()

  setMinDate: ($el) ->
    if $el.data('date-type') == 'end' && $('#giveaway_start_date').val().length
      "#{moment($('#giveaway_start_date').val()).format('M/D/YYYY')}"
    else
      "#{moment().add('minutes', 10).format('M/D/YYYY')}"

  startConflicts: false

  showConflictMessage: (input, conflict) ->
    @conflictContainerEl(input).show().append("<div class='conflict'><strong>#{conflict.title}</strong><br />#{moment(conflict.start_date).format('M/D/YYYY')} - #{moment(conflict.end_date).format('M/D/YYYY')}</div>")

  conflictContainerEl: (input) ->
    $(input).parents('.date-container').children('.conflicts-container')

  dateTimePickerEls: -> $('.datetime-picker')
