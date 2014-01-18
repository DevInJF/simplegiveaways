SG.UI.DataTables =

  _sg: _SG

  initialize: (table) ->
    @initEntriesTable() if table is 'entries'

  initEntriesTable: ->
    @dt = @entriesTableEl().dataTable
      bSort: true
      bProcessing: true
      bServerSide: true
      sAjaxSource: "#{@_sg.Paths.giveawayEntries}"
      sPaginationType: "bootstrap"
      aaSorting: [[@defaultSortIndex(), @defaultSortOrder()]]

  defaultSortIndex: ->
    @entriesTableEl().find('th.default-sort').index()

  defaultSortOrder: ->
    @entriesTableEl().find('th.default-sort').data('default-sort-order') || 'asc'

  entriesTableEl: -> $('#entries_table')
