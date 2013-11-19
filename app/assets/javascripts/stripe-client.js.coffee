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
    @checkboxEl().checkbox(onChange: @updatePrice)
    @planContainerEl().click (e) =>
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
      @openStripeCheckout()

  openPageSelector: ->
    $(@planEl).removeClass('four').addClass('page-selector twelve')

  closePageSelector: ->
    $('.page-selector').find('.resetable').checkbox('disable').
    end().find('.default').checkbox('enable').
    end().removeClass('page-selector twelve').addClass('four')

  pageSelectorVisible: (event) ->
    $(event.target).parents('.page-selector').length || $(event.target).hasClass('page-selector')

  updatePrice: ->
    pageSelector = $('.page-selector')
    quantity = pageSelector.find('input:checked').size()
    currentAmount = parseInt pageSelector.data('original_amount')
    currentPrice = currentAmount / 100
    newPrice = "$#{currentPrice * quantity}.00"
    pageSelector.data('checkout_amount', quantity * currentAmount)
    pageSelector.find('.number.price').text(newPrice)

  openStripeCheckout: ->
    amount = $(@planEl).data('checkout_amount')
    unless amount is 0
      @handler.open
        name: 'Simple Giveaways',
        description: $(@planEl).data('description'),
        amount: amount,
        email: simpleGiveaways.current_user.email

  createSubscription: (token) ->
    $.ajax
      url: SG.Paths.subscribe,
      type: 'POST',
      dataType: 'json',
      data:
        stripe_token: token,
        subscription_plan_id: $(@planEl).data('subscription_plan_id'),
        facebook_page_ids: @mapPageIds()
      success: ->
        top.location.href = "#{document.referrer}?subscribed"
      error: ->
        SG.UI.showFlash('error', 'There was a problem processing the subscription. Please try again or contact support for assistance.')

  mapPageIds: ->
    _.map $(@planEl).find('input:checked'), (input) -> $(input).val()

  setToken: (token) -> @token = token

  fetchToken: -> @token

  checkboxEl: -> $('.ui.checkbox')

  planContainerEl: -> $('.subscription-plan')

  plansContainerEl: -> $('#plan_columns')

  stripeEl: -> $('script#stripe_js')
