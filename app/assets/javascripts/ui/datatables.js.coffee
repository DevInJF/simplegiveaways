SG.UI.DataTables =

  _sg: _SG

  initialize: (table) ->
    @initEntriesTable() if table is 'entries'

  initEntriesTable: ->
    console.log 'initEntriesTable'

    @entriesTableEl().dataTable
      bProcessing: true
      bServerSide: true
      sAjaxSource: "#{@_sg.Paths.giveawayEntries}"
      sPaginationType: "bootstrap"

  entriesTableEl: -> $('#entries_table')
