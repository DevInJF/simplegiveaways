jQuery ->
  $('.ui.dropdown').dropdown()
  $('.ui.checkbox').checkbox()
  $('.ui.modal').modal('setting',
    onApprove: ->
      window.alert 'Approved!'
  ).modal 'attach events', '#start_giveaway', 'show'
