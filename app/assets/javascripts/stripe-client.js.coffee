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
    $('.subscription-plan').click (e) =>
      @planEl = $(e.target).parents('.subscription-plan')
      @handleClick()
      e.preventDefault()

  handleClick: ->
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
        stripe_subscription_id: $(@planEl).attr('id')

  setToken: (token) -> @token = token

  fetchToken: -> @token

  plansContainerEl: -> $('.subscription-plans')

  stripeEl: -> $('script#stripe_js')
