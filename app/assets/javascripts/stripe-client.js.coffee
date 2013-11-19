SG.StripeClient =

  initialize: ->
    if @stripeEl().length
      @configureHandler()
      @attachListener()

  configureHandler: ->
    @handler = StripeCheckout.configure
      key: "#{@publishableKey}",
      token: (data, args) =>
        @createSubscription(data.id)

  attachListener: ->
    @checkboxEl().checkbox(onChange: @updatePriceDisplay)
    @planContainerEl().click (e) =>
      if @pageSelectorVisible(e)
        @closePageSelector() if $(e.target).hasClass('remove')
        @openStripeCheckout() if $(e.target).hasClass('check')
      else
        @planEl = $(e.target).parents('.subscription-plan')
        @handleClick()
        e.preventDefault()

  handleClick: ->
    @closePageSelector()
    if $(@planEl).data('is_single_page')
      @openPageSelector()
    else
      @openStripeCheckout()

  openPageSelector: ->
    $(@planEl).removeClass('four').addClass('page-selector twelve')

  closePageSelector: ->
    $('.page-selector').find('.resetable').checkbox('disable').end().find('.default').checkbox('enable').end().removeClass('page-selector twelve').addClass('four')

  pageSelectorVisible: (event) ->
    $(event.target).parents('.page-selector').length || $(event.target).hasClass('page-selector')

  updatePriceDisplay: ->
    quantity = $('.page-selector').find('input:checked').size()
    currentAmount = parseInt($('.page-selector').data('amount'))
    currentPrice = currentAmount / 100
    newPrice = "$#{currentPrice * quantity}.00"
    $('.page-selector').find('.number.price').text(newPrice)

  openStripeCheckout: ->
    @handler.open
      name: 'Simple Giveaways',
      description: $(@planEl).data('description'),
      amount: $(@planEl).data('amount'),
      email: simpleGiveaways.current_user.email

  createSubscription: (token) ->
    $.ajax
      url: SG.Paths.subscribe,
      type: 'POST',
      dataType: 'json',
      data:
        stripe_token: token,
        subscription_plan_id: $(@planEl).data('subscription_plan_id')
      success: ->
        top.location.href = "#{document.referrer}?subscribed"
      error: ->
        SG.UI.showFlash('error', 'There was a problem processing the subscription. Please try again or contact support for assistance.')

  setToken: (token) -> @token = token

  fetchToken: -> @token

  checkboxEl: -> $('.ui.checkbox')

  planContainerEl: -> $('.subscription-plan')

  plansContainerEl: -> $('#plan_columns')

  stripeEl: -> $('script#stripe_js')
