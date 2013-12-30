SG.Giveaways.Form =

  initialize: ->
    if @formEl().length
      @initWizard()
      @initBonusEntriesToggle()

  initWizard: ->
    @formEl().wizard()
    @formEl().on 'change', (e, data) =>
      validated = true
      $("[data-required='true']", @containerEl().find("#step#{data.step}")).each ->
        validated = $(this).parsley('validate')
      console.log data
      false if data.direction == 'next' && not validated

  initBonusEntriesToggle: ->
    $('#giveaway_allow_multi_entries').parents('.checkbox').checkbox(onChange: @toggleBonusEntries)

  toggleBonusEntries: ->
    $('#bonus_value_wrapper').toggle()

  containerEl: -> @formEl().parents('.wizard-container')

  formEl: -> $('#form-wizard')
