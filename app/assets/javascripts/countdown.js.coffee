jQuery ->

  if $('div.countdown-timer').length
    currentDate = new Date()
    countdownTarget = simpleGiveaways["active_giveaway"]["countdown_target"]

    iteration = 0
    countdownOptions = (event) ->
      if event.type == "daysLeft" && _.include([0, "0", "00"], event.value)
        $(@).find(".seconds.time-wrapper").show()
      else
        $(@).find(".seconds.time-wrapper").hide()
      if iteration == 0 && _.include([0, "0", "00"], event.value)
        $(@).find("span.#{event.type}.time-wrapper").remove()
      else
        iteration += 1
        $(@).find("span##{event.type}").html(event.value)

    $('div.countdown-timer').countdown(countdownTarget, countdownOptions)
