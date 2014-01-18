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
      aaSorting: [[@defaultSortIndex(), @defaultSortOrder()]]
      sDom: "<'row'<'col-sm-6'l><'col-sm-6'f>r>t<'row'<'col-sm-12'<'text-center'p><'text-center'i>>>"
      sPaginationType: "full_numbers"

  defaultSortIndex: ->
    @entriesTableEl().find('th.default-sort').index()

  defaultSortOrder: ->
    @entriesTableEl().find('th.default-sort').data('default-sort-order') || 'asc'

  entriesTableEl: -> $('#entries_table')
