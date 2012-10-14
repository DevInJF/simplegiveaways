jQuery ->

  if $('btn.zclip').length

    _sg = simpleGiveaways

    $('a.btn.zclip').zclip(
      path: '/ZeroClipboard.swf'
      copy: -> _sg.active_giveaway.shortlink
      afterCopy: ->
        $(this).addClass('hide')
        $('a.btn.zclip-success').removeClass('hide')
        $(body).trigger('click')
    )