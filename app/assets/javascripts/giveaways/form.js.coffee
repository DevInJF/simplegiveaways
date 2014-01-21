SG.Giveaways.Form =

  _sg: _SG

  initialize: ->
    if @wizardEl().length
      @initWizard()
      @initBonusEntriesToggle()
      unless @_sg.CurrentGiveaway.status == 'Active'
        @checkSchedule(el) for el in SG.UI.DatetimePickers.dateTimePickerEls()
    @processErrors() if @errors().length

  initWizard: ->
    @wizardEl().wizard()
    @wizardEl().on 'change', (e, data) => @onWizardChange(e, data)
    @wizardEl().on 'finished', (e, data) => @onWizardFinished(e, data)

  checkSchedule: (el) ->
    $el = $(el)
    unless SG.UI.DatetimePickers.startConflicts && SG.UI.DatetimePickers.isEnd($el)
      SG.UI.DatetimePickers.conflictContainerEl($el).find('.conflict').remove()
      SG.UI.DatetimePickers.checkSchedule($el.val(), $el)

  onWizardChange: (e, data) ->
    validated = true
    CKEDITOR.instances.editor.updateElement()
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
    $('#giveaway_allow_multi_entries').on 'change', =>
      @toggleBonusEntries()

  toggleBonusEntries: ->
    $('.giveaway_bonus_value').toggle()

  processErrors: ->
    @wizardEl().find("li[data-target='##{@firstErrorStep()}']").trigger 'click'

  errors: -> @containerEl().find('.has-error')

  firstErrorStep: -> @errors().first().parents('.step-pane').attr('id')

  containerEl: -> @wizardEl().parents('.wizard-container')

  formErrorsEl: -> @containerEl().find('.error-messages')

  wizardEl: -> $('#form-wizard')

  basicInfoStepEl: -> @wizardEl().find('li[data-target="#step1"]')

  scheduleStepEl: -> @wizardEl().find('li[data-target="#step2"]')

  imagesStepEl: -> @wizardEl().find('li[data-target="#step3"]')

  termsStepEl: -> @wizardEl().find('li[data-target="#step4"]')

  optionsStepEl: -> @wizardEl().find('li[data-target="#step5"]')
