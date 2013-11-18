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
    @planContainerEl().click (e) =>
      @planEl = $(e.target).parents('.subscription-plan')
      @handleClick()
      e.preventDefault()

  handleClick: ->
    if $(@planEl).data('is_single_page')
      @openPageSelector()
    else
      @openStripeCheckout()

  openPageSelector: ->
    $(@planEl).addClass('page-selector')

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

  planContainerEl: -> $('.subscription-plan')

  plansContainerEl: -> $('.subscription-plans')

  stripeEl: -> $('script#stripe_js')
