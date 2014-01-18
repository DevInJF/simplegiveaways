SG.UI =

  initialize: ->
    SG.UI.FlashMessages.initialize()
    @initReadmores()
    @initAutosize()
    SG.UI.ZClip.initialize()
    SG.UI.DatetimePickers.initialize()
    SG.UI.Editables.initialize()

  initAutosize: ->
    $('textarea').autosize()

  initReadmores: ->
    @initReadmore(el) for el in @readmoreEls()

  initReadmore: (el) ->
    $(el).jTruncate()

  initFilestyle: ->
    @fileInputEls().filestyle
      classButton: 'btn btn-default btn-lg'
      classInput: 'form-control inline input-s'
      icon: true
      buttonText: 'Upload'
      input: false
      classIcon: 'fa fa-cloud-upload text'

  readmoreEls: -> $('.readmore')

  fileInputEls: -> $(':file')
