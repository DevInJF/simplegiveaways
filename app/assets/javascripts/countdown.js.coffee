jQuery ->

  if $('div.countdown-timer').length
    currentDate = new Date()
    countdownTarget = simpleGiveaways["active_giveaway"]["countdown_target"]

    countdownOptions = (event) ->
      $(@).find("span##{event.type}").html(event.value)

    $('div.countdown-timer').countdown(countdownTarget, countdownOptions)