SG.UI =

  initialize: ->
    SG.UI.FlashMessages.initialize()
    @initReadmores()
    @initAutosize()
    @initPagination()
    SG.UI.ZClip.initialize()
    SG.UI.DatetimePickers.initialize()
    SG.UI.Editables.initialize()

  initReadmores: ->
    @initReadmore(el) for el in @readmoreEls()

  initAutosize: ->
    $('textarea').autosize()

  initPagination: ->
    @paginationEls().rPage()

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

  paginationEls: -> $('ul.pagination')

  fileInputEls: -> $(':file')
