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

    datepicker = $container.find('.date-trigger').pickadate
      container: $container.find('.pickadate-outlet')
      format: 'dddd, mmmm dd, yyyy'
      min: @setMinDate($el)
      onSet: (item) ->
        setTimeout timepicker.open, 0  if 'select' of item
    .pickadate('picker')

    timepicker = $container.find('.time-trigger').pickatime
      container: $container.find('.pickadate-outlet')
      onRender: ->
        $('<span class="btn btn-default btn-block">Back to Date</span>').on 'click', ->
          timepicker.close()
          datepicker.open()
        .prependTo @$root.find('.picker__box')
      onSet: (item) =>
        if 'select' of item
          setTimeout (=> @onDateTimeSet($el, datepicker, timepicker)), 0
    .pickatime('picker')

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
    console.log $el
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
