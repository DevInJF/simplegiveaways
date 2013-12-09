SG.StripeClient =

  initialize: ->
    if @stripeEl().length
      @configureHandler()
      @attachListener()

  configureHandler: ->
    @handler = StripeCheckout.configure
      key: "#{@publishableKey}"
      token: (data, args) =>
        @createSubscription(data.id)

  attachListener: ->
    @planContainerEls().click (e) =>
      if @pageSelectorVisible(e)
        @closePageSelector() if $(e.target).hasClass('remove')
        @openStripeCheckout() if $(e.target).hasClass('check')
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
        email: simpleGiveaways.current_user.email

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
        SG.UI.FlashMessages.showFlash('error', 'Error','There was a problem processing the subscription. Please try again or contact support for assistance.')

  mapPageIds: ->
    _.map $(@planEl).find('input:checked'), (input) -> $(input).val()

  setToken: (token) -> @token = token

  fetchToken: -> @token

  checkboxEl: -> $('.ui.checkbox')

  planContainerEls: -> $('.subscription-plan')

  plansContainerEl: -> $('#plan_columns')

  isUserCentric: ->
    @plansContainerEl().data('is-user-centric')

  ajaxPath: ->
    @isUserCentric() && SG.Paths.userSubscribe || SG.Paths.pageSubscribe

  stripeEl: -> $('script#stripe_js')
