SG.Giveaways.Form =

  initialize: ->
    if @formEl().length
      @initWizard()
      @initBonusEntriesToggle()

  initWizard: ->
    @formEl().wizard()
    @formEl().on 'change', (e, data) =>
      validated = null
      $("[data-required='true']", @formEl().parents('.wizard-container').find("#step#{data.step}")).each ->
        validated = $(this).parsley('validate')
      false if data.direction == 'next' && not validated

  initBonusEntriesToggle: ->
    $('#giveaway_allow_multi_entries').parents('.checkbox').checkbox(onChange: @toggleBonusEntries)

  toggleBonusEntries: ->
    $('#bonus_value_wrapper').toggle()

  formEl: -> $('#form-wizard')
