SG.UI.ZClip =

  initialize: ->
    @attachZClip(el) for el in @zClipEls()

  attachZClip: (el) ->
    $el = $(el)
    clip = new ZeroClipboard($el)
    clip.on 'complete', ->
      $el.addClass('zclip-success').
      find('i.icon').attr('class', 'icon check')

  zClipEls: -> $('a.zclip-trigger')
