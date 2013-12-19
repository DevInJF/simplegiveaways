SG.StripeClient =

  _sg: _SG

  initialize: ->
    if @stripeEl().length
      @configureHandler()
      @attachListener()

  configureHandler: ->
    @handler = StripeCheckout.configure
      key: "#{@_sg.Config.STRIPE_KEY}"
      token: (data, args) =>
        @createSubscription(data.id)

  attachListener: ->
    @planContainerEls().click (e) =>
      if @pageSelectorVisible(e)
        @handlePageSelectorClick(e)
      else
        @planEl = $(e.target).hasClass('subscription-plan') && $(e.target) || $(e.target).parents('.subscription-plan')
        @handleClick()
        e.preventDefault()

  handleClick: ->
    @closePageSelector()
    if $(@planEl).data('is_single_page')
      @openPageSelector()
    else
      if $(@planEl).data('is_current_plan') || $(@planEl).data('is_next_plan')
        @openPageSelector()
      else
        @openStripeCheckout()

  handlePageSelectorClick: (event) ->
    if $(event.target).hasClass('remove')
      @closePageSelector()
    else if $(event.target).hasClass('check')
      if @mapPageIds().length
        @handleFormSubmit()
      else
        $(@planEl).find('legend').css('font-weight', 'bold')

  handleFormSubmit: ->
    if $(@planEl).data('is_current_plan') || $(@planEl).data('is_next_plan')
      @handleCurrentOrNextPlan()
    else
      @handleNewPlan()

  handleCurrentOrNextPlan: ->
    if @pageChangeWarning?
      @createSubscription('page_change') if confirm @pageChangeWarning
    else
      @createSubscription('page_change')

  handleNewPlan: ->
    if @pageChangeWarning?
      @openStripeCheckout() if confirm @pageChangeWarning
    else
      @openStripeCheckout()

  openPageSelector: ->
    $(@planEl).removeClass('five').addClass('page-selector six')

  closePageSelector: ->
    $('.page-selector').find('.resetable').checkbox('disable').
    end().find('.default').checkbox('enable').
    end().removeClass('page-selector six').addClass('five')

  pageSelectorVisible: (event) ->
    $(event.target).parents('.page-selector').length || $(event.target).hasClass('page-selector')

  openStripeCheckout: ->
    amount = $(@planEl).data('checkout_amount')
    unless amount is 0
      @handler.open
        name: 'Simple Giveaways'
        description: $(@planEl).data('description')
        amount: amount
        email: @_sg.CurrentUser.email

  createSubscription: (token) ->
    $.ajax
      url: @ajaxPath()
      type: 'POST'
      dataType: 'json'
      data:
        stripe_token: token
        subscription_plan_id: $(@planEl).data('subscription_plan_id')
        facebook_page_ids: @mapPageIds()
      success: (data) =>
        top.location.href = "#{data.redirect_path}"
      error: =>
        SG.UI.FlashMessages.showFlash('error', 'Error', 'There was a problem processing the subscription. Please try again or contact support for assistance.')

  mapPageIds: ->
    _.map $(@planEl).find('input:checked'), (input) =>
      @pageChangeWarning = $(input).hasClass('page-change-warning') && "#{$(input).data('page-change-warning')}" || null
      $(input).val()

  checkboxEl: -> $('.ui.checkbox')

  planContainerEls: -> $('.subscription-plan')

  plansContainerEl: -> $('#plan_columns')

  isUserCentric: ->
    @plansContainerEl().data('is-user-centric')

  ajaxPath: ->
    @isUserCentric() && @_sg.Paths.userSubscribe || @_sg.Paths.pageSubscribe

  stripeEl: -> $('script#stripe_js')
