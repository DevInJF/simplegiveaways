SG.Giveaways.Form =

  initialize: ->
    if @formEl().length
      SG.Giveaways.Form.WYSIWYG.initialize()
      @initWizard()
      @initBonusEntriesToggle()

  initWizard: ->
    @formEl().wizard()
    @formEl().on 'change', (e, data) => @onWizardChange(e, data)
    @formEl().on 'finished', (e, data) => @onWizardFinished(e, data)

  onWizardChange: (e, data) ->
    validated = true
    $("[data-required='true']", @containerEl().find("#step#{data.step}")).each ->
      validated = $(this).parsley('validate')
    false if data.direction == 'next' && not validated

  onWizardFinished: (e, data) ->
    validated = true
    $("[data-required='true']", @containerEl().find("#step5")).each ->
      validated = $(this).parsley('validate')
    return false if not validated
    @containerEl().find('form').submit()

  initBonusEntriesToggle: ->
    $('#giveaway_allow_multi_entries').parents('.checkbox').checkbox(onChange: @toggleBonusEntries)

  toggleBonusEntries: ->
    $('#bonus_value_wrapper').toggle()

  editorEl: -> $('#editor')

  containerEl: -> @formEl().parents('.wizard-container')

  formEl: -> $('#form-wizard')
