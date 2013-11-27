SG.Giveaways.Active =

  initialize: ->
    @initEntriesTable()

  initEntriesTable: ->
    @entriesTableEl().footable
      delay: 20
      breakpoints:
        phone: 480
        tablet: 705
        full: 900

  initGraphs: ->
    @initGraphData()
    @plotWithOptions()

  plotWithOptions: ->
    $.plot @graphPlaceholderEl(), @graphData, @graphOptions

  initGraphData: ->

    @graphDatasets = {}

    if @flot_page_likes()
      @graphDatasets["page_likes"] =
        label: "Likes"
        data: @flot_page_likes()

    if @flot_net_likes()
      @graphDatasets["net_likes"] =
        label: "Net Likes"
        data: @flot_net_likes()

    if @flot_entries()
      @graphDatasets["entry_count"] =
        label: "Entries"
        data: @flot_entries()

    if @flot_views()
      @graphDatasets["view_count"] =
        label: "Views"
        data: @flot_views()

    for key, val of @graphDatasets
      @graphData.push @graphDatasets[key]

  graphData: []

  flot_page_likes: -> SG.Graphs.pageLikes

  flot_net_likes: -> SG.Graphs.netLikes

  flot_entries: -> SG.Graphs.entries

  flot_views: -> SG.Graphs.views

  graphOptions:
    series:
      stack: false
      lines:
        show: true
        fill: false
        steps: false
    xaxis:
      mode: "time"
      tickSize: [1, "day"]
      minTickSize: [1, "day"]
    yaxis:
      tickDecimals: 0
      min: 0
    grid:
      clickable: true
      hoverable: true
    points:
      show: true
    colors: [ "#FAA732", "#5BB75B", "#49AFCD", "#0055cc" ]
    tooltip: true
    tooltipOpts:
      content: "<span class='graph-tip-y'><strong>%y</strong> <span class='graph-tip-y-label'>%s</span></span><br /><span class='graph-tip-x'><span class='graph-tip-x-val'>%x</span></span>"
      onHover: (flotItem, $tooltipEl) ->
        $tooltipEl.css('border-color', flotItem.series.color)

  graphPlaceholderEl: -> $('#graph_placeholder')

  entriesTableEl: -> $('.footable')
