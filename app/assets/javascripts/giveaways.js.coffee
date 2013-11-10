SG.Giveaways =

  initialize: ->
    @initStartModal()
    @initButtons()

  initStartModal: ->
    @sidebarEl().sidebar(
      overlay: true
    ).sidebar 'attach events', '#start_giveaway'

  initButtons: ->
    @approveButtonEl().click => @moveForward()
    @denyButtonEl().click => @sidebarEl().sidebar 'hide'

  moveForward: ->
    current = @currentStepEl()
    next = @nextStepEl()
    current.hide()
    next.show()

  currentStep: ->
    @currentStepEl().data('modal-step')

  currentStepEl: ->
    @sidebarEl().find('.modal-step:visible')

  nextStep: ->
    parseInt(@currentStep()) + 1

  nextStepEl: ->
    @sidebarEl().find(".modal-step[data-modal-step='#{@nextStep()}']").first()

  denyButtonEl: -> @sidebarEl().find('.deny.button')

  approveButtonEl: -> @sidebarEl().find('.approve.button')

  sidebarEl: -> $('.ui.sidebar')
