jQuery ->

  if $('div.countdown-timer').length
    currentDate = new Date()
    countdownTarget = simpleGiveaways["active_giveaway"]["countdown_target"]

    countdownOptions = (event) ->
      if _.include([0, "0", "00"], event.value)
        $(@).find("span.#{event.type}.time-wrapper").remove()
      else
        $(@).find("span##{event.type}").html(event.value)

    $('div.countdown-timer').countdown(countdownTarget, countdownOptions)