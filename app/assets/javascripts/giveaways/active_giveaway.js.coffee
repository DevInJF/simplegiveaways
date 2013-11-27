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
    @plot = @plotWithOptions()
    @previousPoint = null
    @graphPlaceholderEl().on 'plothover', (event, pos, item) =>
      if item? then @itemHover(item) else @canvasHover()

  plotWithOptions: ->
    $.plot @graphPlaceholderEl(), @graphData, @graphOptions

  showTooltip: (x, y, contents) ->
    $("<div class='graph-tooltip'>#{contents}</div>").css(
      position: 'absolute'
      display: 'none'
      top: y + 12
      left: x + 12
    ).appendTo("body").stop().fadeIn(150)

  canvasHover: ->
    @plot.unhighlight()
    $(".graph-tooltip").remove()
    @previousPoint = null

  itemHover: (item) ->
    if @previousPoint != item.dataIndex
      @previousPoint = item.dataIndex

      @plot.unhighlight()
      $(".graph-tooltip").remove()

      @plot.highlight(item.series, item.datapoint)

      x = new Date(item.datapoint[0])
      y = item.datapoint[1]

      @showTooltip(item.pageX, item.pageY, "<span class='graph-tip-y'>" + y + " <span class='graph-tip-y-label' style='color:" + item.series.color + "'>" + item.series.label + "</span></span><br /><span class='graph-tip-x'><span class='graph-tip-x-val'>" + x.getMonth() + "/" + x.getDay() + "/" + x.getFullYear() + "</span></span>")

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

  graphPlaceholderEl: -> $('#graph_placeholder')

  entriesTableEl: -> $('.footable')
