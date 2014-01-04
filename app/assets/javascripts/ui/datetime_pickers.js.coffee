SG.UI.DatetimePickers =

  _sg: _SG

  initialize: (el) ->
    if el?
      @attachDatetimePicker(el)
    else
      @attachDatetimePicker(el) for el in @dateTimePickerEls()

  attachDatetimePicker: (el) ->
    $el = $(el)
    $container = $el.parents('.date-container')
    $outlet = $container.find('.pickadate-outlet')
    $dateTriggerEl = $container.find('.date-trigger')
    $timeTriggerEl = $container.find('.time-trigger')

    datepicker = @attachDatepicker($el, $outlet, $dateTriggerEl)
    timepicker = @attachTimepicker($el, $outlet, $timeTriggerEl)

    @initDatepicker($el, $dateTriggerEl, datepicker, timepicker)
    @initTimepicker($el, $timeTriggerEl, datepicker, timepicker)

    @initPickerTrigger($el, datepicker)

  attachDatepicker: ($el, $outlet, $dateTriggerEl) ->
    $dateTriggerEl.pickadate
      container: $outlet
      format: 'dddd, mmmm dd, yyyy'
      min: @setMinDate($el)
    .pickadate('picker')

  initDatepicker: ($el, $dateTriggerEl, datepicker, timepicker) ->
    datepicker.on
      set: (item) -> setTimeout timepicker.open, 0  if 'select' of item

  attachTimepicker: ($el, $outlet, $timeTriggerEl) ->
    $timeTriggerEl.pickatime
      container: $outlet
    .pickatime('picker')

  initTimepicker: ($el, $timePickerEl, datepicker, timepicker) ->
    timepicker.on
      render: ->
        $('<span class="btn btn-default btn-block">Back to Date</span>').on 'click', ->
          timepicker.close()
          datepicker.open()
        .prependTo timepicker.$root.find('.picker__box')
      set: (item) =>
        if 'select' of item
          setTimeout (=> @onDateTimeSet($el, datepicker, timepicker)), 0

  initPickerTrigger: ($el, datepicker) ->
    $el.on('focus', datepicker.open).on 'click', (event) ->
      event.stopPropagation()
      datepicker.open()

  onDateTimeSet: ($el, datepicker, timepicker) ->
    $el.off('focus').val("#{datepicker.get()} @ #{timepicker.get()}").focus()
    datepicker.stop()
    timepicker.stop()
    # unless @startConflicts && $input.data('date-type') == 'end'
    #   @conflictContainerEl($input).find('.conflict').remove()
    #   @checkSchedule(current, $input)

  dateType: ($el) ->
    ($el.parents('#giveaway_start_date').length && 'start') || ($el.parents('#giveaway_end_date').length && 'end')

  isStart: ($el) ->
    @dateType($el) == 'start'

  isEnd: ($el) ->
    @dateType($el) == 'end'

  startDate: ($el) ->
    if $el.hasClass('datetime-picker-input')
      $('#giveaway_start_date').find('.datetime-picker-input').val()
    else
      $('#giveaway_start_date').data('date')? && $('#giveaway_start_date').data('date')

  endDate: ->
    $('#giveaway_end_date').data('date')? && $('#giveaway_end_date').data('date')

  checkSchedule: (datetime, input) ->
    $.ajax
      url: @_sg.Paths.checkSchedule
      dataType: 'json',
      data:
        giveaway_id: @_sg.CurrentGiveaway.ID
        facebook_page_id: @_sg.CurrentPage.ID
        date: datetime
        date_type: @dateType($(input))
      success: (conflicts, status) =>
        if conflicts.length
          @startConflicts = true if @isStart($(input))
          @showConflictMessage(input, conflict) for conflict in conflicts
        else
          @startConflicts = false if @isStart($(input))
          @conflictContainerEl(input).hide()

  setMinDate: ($el) ->
    if @isEnd($el) && (start = @startDate($el))
      moment(start).toDate()
    else
      moment().add('minutes', 10).toDate()

  startConflicts: false

  showConflictMessage: (input, conflict) ->
    @conflictContainerEl(input).show().append("<div class='conflict'><strong>#{conflict.title}</strong><br />#{moment(conflict.start_date).format('M/D/YYYY')} - #{moment(conflict.end_date).format('M/D/YYYY')}</div>")

  conflictContainerEl: (input) ->
    $(input).parents('.date-container').children('.conflicts-container')

  dateTimePickerEls: -> $('.datetime-picker-input')
