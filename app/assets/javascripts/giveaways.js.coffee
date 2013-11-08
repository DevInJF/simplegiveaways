SG.Giveaways =

  initialize: ->
    @initStartModal()

  initStartModal: ->
    @modalEl().modal 'setting',
      onApprove: =>
        @moveForward()
        false
    .modal 'attach events', '#start_giveaway', 'show'

  moveForward: ->
    current = @currentStepEl()
    next = @nextStepEl()
    current.hide()
    next.show()

  currentStep: ->
    @currentStepEl().data('modal-step')

  currentStepEl: ->
    @modalEl().find('.modal-step:visible')

  nextStep: ->
    parseInt(@currentStep()) + 1

  nextStepEl: ->
    @modalEl().find(".modal-step[data-modal-step='#{@nextStep()}']").first()

  modalEl: -> $('.ui.modal')
