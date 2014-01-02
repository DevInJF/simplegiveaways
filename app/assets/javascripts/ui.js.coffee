SG.UI =

  initialize: ->
    SG.UI.ZClip.initialize()
    SG.UI.DatetimePickers.initialize()
    SG.UI.FlashMessages.initialize()
    @initDropdowns()
    @initCheckboxes()
    @initAccordions()
    @initPopups()
    @initReadmores()
    @initEditables()

  initDropdowns: ->
    @dropdownEls().dropdown(debug: false) if @dropdownEls().length

  initCheckboxes: ->
    @checkboxEls().checkbox(debug: false) if @checkboxEls().length

  initAccordions: ->
    @accordionEls().accordion(debug: false) if @accordionEls().length

  initPopups: ->
    @initPopup(el) for el in @popupEls()

  initPopup: (el) ->
    $(el).popup
      debug: false
      on: $(el).data('on')

  initReadmores: ->
    @initReadmore(el) for el in @readmoreEls()

  initReadmore: (el) ->
    $(el).jTruncate()

  initEditables: ->
    $.fn.editableform.buttons = '<button type="submit" class="editable-submit btn btn-sm btn-primary"><i class="fa fa-check"></i></button><button type="button" class="editable-cancel btn btn-sm btn-default"><i class="fa fa-times"></i></button>'
    @initEditable(el) for el in @editableEls()
    @initEditableTrigger(el) for el in @editableTriggerEls()

  initEditable: (el) ->
    @initReadmoreEditables(el)
    $(el).editable
      mode: $(el).data('editable-mode') || 'inline'
      autotext: 'always'
    @initEditableShown(el)

  initReadmoreEditables: (el) ->
    $(el).on 'init', (e, editable) ->
      if editable.$element.length && editable.$element.hasClass('editable-readmore')
        SG.UI.initReadmore($(this))

  initEditableShown: (el) ->
    $(el).on 'shown', (e, editable) ->
      if editable.$element.length && editable.$element.hasClass('editable-datetime')
        SG.UI.DatetimePickers.initialize editable.input.$input
      else if editable.$element.length && editable.$element.hasClass('editable-wysiwyg')
        SG.Giveaways.Form.WYSIWYG.initialize editable.input.$input

  initEditableTrigger: (el) ->
    $(el).on 'click', (e) =>
      e.stopPropagation()
      $(el).parents('tr').find('.editable').editable('toggle')

  dropdownEls: -> $('.ui.dropdown')

  checkboxEls: -> $('.ui.checkbox').not('.radio')

  accordionEls: -> $('.ui.accordion')

  popupEls: -> $('.popup-trigger')

  readmoreEls: -> $('.readmore')

  editableEls: -> $('.editable')

  editableTriggerEls: -> $('.editable-trigger')
