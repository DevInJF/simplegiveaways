SG.Giveaways =

  initialize: ->
    @initStartModal()

  initStartModal: ->
    @modalEl().modal(
      onApprove: =>
        @moveForward()
        false
    ).modal 'attach events', '#start_giveaway'

  moveForward: ->
    current = @currentStepEl()
    next = @nextStepEl()
    if next.find('#free_trial_remaining').length
      top.location.href = SG.Paths.subscriptionPlans
    else
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

  denyButtonEl: -> @modalEl().find('.deny.button')

  approveButtonEl: -> @modalEl().find('.approve.button')

  modalEl: -> $('.ui.modal.start-giveaway')
