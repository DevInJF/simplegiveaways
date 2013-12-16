SG.Giveaways.Form =

  initialize: ->
    @initBonusEntriesToggle() if @formEl().length

  initBonusEntriesToggle: ->
    $('#giveaway_allow_multi_entries').parents('.checkbox').checkbox(onChange: @toggleBonusEntries)

  toggleBonusEntries: ->
    $('#bonus_value_wrapper').toggle()

  formEl: -> $("form.giveaway-form")
