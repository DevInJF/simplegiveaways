SG.Giveaways.Active =

  initialize: ->
    @initTabListeners() if @tabsContainerEl().length
    SG.Giveaways.Active.Graphs.initialize()

  initTabListeners: ->
    $(document).on 'ajax:beforeSend', '#details_tab_trigger', (xhr, data, s) =>
      return false if @detailsTabTriggerEl().hasClass('loaded')

    $(document).on 'ajax:success', '#details_tab_trigger', (xhr, data, s) =>
      @initDetailsTab(data)

    $(document).on 'ajax:beforeSend', '#entries_tab_trigger', (xhr, data, s) =>
      return false if @entriesTabTriggerEl().hasClass('loaded')

    $(document).on 'ajax:success', '#entries_tab_trigger', (xhr, data, s) =>
      @initEntriesTab(data)

    $(document).on 'footable_initialized', '#entries_table', ->
      setTimeout (=> $(this).trigger('footable_resize')), 100

    @tabEls().on 'shown.bs.tab', (e) =>
      if $(e.target).is @detailsTabTriggerEl()
        @detailsTabEl().find('.sg-progress-block .bar').addClass('loading')
      else if $(e.target).is @entriesTabTriggerEl()
        @entriesTabEl().find('.sg-progress-block .bar').addClass('loading')

  initEntriesTable: ->
    @entriesTableEl().footable
      delay: 0
      breakpoints:
        mini: 420
        phone: 500
        tablet: 768
        full: 992

  initDetailsTab: (data) ->
    @detailsTabEl().html(data) if data
    @detailsTabTriggerEl().addClass('loaded')
    SG.Giveaways.Details.reinitialize()

  initEntriesTab: (data) ->
    @entriesTabEl().html(data) if data
    @entriesTabTriggerEl().addClass('loaded')
    @initEntriesTable()

  entriesTableEl: -> $('#entries_table')

  detailsTabTriggerEl: -> $('#details_tab_trigger')

  detailsTabEl: -> $('#details_tab')

  entriesTabTriggerEl: -> $('#entries_tab_trigger')

  entriesTabEl: -> $('#entries_tab')

  overviewTabTriggerEl: -> $('#overview_tab_trigger')

  overviewTabEl: -> $('#overview_tab')

  tabEls: -> @tabsContainerEl().find('a[data-toggle="tab"]')

  tabsContainerEl: -> $('#active_giveaway_tabs')
