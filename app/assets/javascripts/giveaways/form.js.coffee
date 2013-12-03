SG.Giveaways.Form =

  initialize: ->
    @initScheduleChecker()

  initScheduleChecker: ->
    @dateEls().on 'blur', (e) => @checkSchedule(e)

  checkSchedule: (event) ->
    date = $(event.target).val()
    console.log date

  dateEls: -> @startDateEl().add @endDateEl()

  startDateEl: -> $('#giveaway_start_date')

  endDateEl: -> $('#giveaway_end_date')
