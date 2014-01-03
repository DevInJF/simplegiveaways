SG.UI.DatetimePickers =

  _sg: _SG

  initialize: (el) ->
    if el?
      @attachDatetimePicker(el)
    else
      @attachDatetimePicker(el) for el in @dateTimePickerEls()

  attachDatetimePicker: (el, inline = false) ->
    $el = $(el)

    $el.pickadate
      # step: 15
      editable: false
      format: "dddd, mmmm dd, yyyy"
      # formatDate: "m/d/Y"
      # formatTime: "h:i A"
      # inline: inline
      min: @setMinDate($el)
      onSet: (event) =>
        # unless @startConflicts && $input.data('date-type') == 'end'
        #   @conflictContainerEl($input).find('.conflict').remove()
        #   @checkSchedule(current, $input)

  dateType: ($el) ->
    ($el.parents('#giveaway_start_date').length && 'start') || ($el.parents('#giveaway_end_date').length && 'end')

  isStart: ($el) ->
    @dateType($el) == 'start'

  isEnd: ($el) ->
    @dateType($el) == 'end'

  startDate: ->
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
    if @isEnd($el) && (start = @startDate())
      moment(start).toDate()
    else
      moment().add('minutes', 10).toDate()

  startConflicts: false

  showConflictMessage: (input, conflict) ->
    @conflictContainerEl(input).show().append("<div class='conflict'><strong>#{conflict.title}</strong><br />#{moment(conflict.start_date).format('M/D/YYYY')} - #{moment(conflict.end_date).format('M/D/YYYY')}</div>")

  conflictContainerEl: (input) ->
    $(input).parents('.date-container').children('.conflicts-container')

  dateTimePickerEls: -> $('.datetime-picker')
