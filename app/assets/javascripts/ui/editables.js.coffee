SG.UI.Editables =

  initialize: ->
    @initEditables() if @editableEls().length

  initEditables: ->
    $.fn.editableform.buttons = '<button type="submit" class="editable-submit btn btn-xs btn-primary"><i class="fa fa-check"></i></button><button type="button" class="editable-cancel btn btn-xs btn-default"><i class="fa fa-times"></i></button>'
    @initEditable(el) for el in @editableEls()
    @initEditableUploads(el) for el in @editableUploadEls()
    @initEditableTrigger(el) for el in @editableTriggerEls()
    @initEditableUploadTrigger(el) for el in @editableUploadTriggerEls()

  initEditable: (el) ->
    @initReadmoreEditables(el)
    $(el).editable
      mode: $(el).data('editable-mode') || 'inline'
      autotext: 'always'
      escape: false
      success: (response, newValue) =>
        if response.errors?
          setTimeout (-> $(el).editable('setValue', $(el).data('editable').options.value)), 1000
        else
          if $(el).hasClass('editable-datetime')
            $(el).parents('.date-container').data('date', newValue)
    @initEditableShown(el)

  initReadmoreEditables: (el) ->
    $(el).on 'init', (e, editable) ->
      if editable.$element.length && editable.$element.hasClass('editable-readmore')
        SG.UI.initReadmore($(this))

  initEditableShown: (el) ->
    $(el).on 'shown', (e, editable) ->
      if editable.$element.length
        if editable.$element.hasClass('editable-datetime')
          SG.UI.DatetimePickers.initialize editable.input.$input
        else if editable.$element.hasClass('editable-wysiwyg')
          SG.Giveaways.Form.WYSIWYG.initialize editable.input.$input
        else if editable.$element.hasClass('editable-textarea')
          SG.UI.initAutosize()

  initEditableUploads: (el) ->
    $(el).on 'change', ->
      $form = $(this).parents('form')
      $form.find('label.btn').text('Uploading...').addClass('disabled')
        .end().submit()

  initEditableUploadTrigger: (el) ->
    $(el).on 'click', (e) ->
      console.log $(el)
      $(el).parents('section').toggleClass('edit-mode')
      return false
    $('form .form-group').on 'click', (e) ->
      e.stopPropagation()

  initEditableTrigger: (el) ->
    $(el).on 'click', (e) =>
      e.stopPropagation()
      $(el).next('.editable').editable('toggle')
      return false

  editableUploadTriggerEls: -> $('.editable-upload-trigger')

  editableTriggerEls: -> $('.editable-trigger')

  editableUploadEls: -> $('form input[type="file"]')

  editableEls: -> $('.editable')
