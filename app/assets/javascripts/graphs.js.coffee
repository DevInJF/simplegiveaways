jQuery ->

  if $('.graph-placeholder').length

    _sg = simpleGiveaways

    data = []
    datasets = {}

    flot_page_likes = _sg.flot.page_likes
    flot_entries = _sg.flot.entries
    flot_views = _sg.flot.views

    if flot_page_likes
      datasets["page_likes"] =
        label: "Likes"
        data: flot_page_likes

    if flot_entries
      datasets["entry_count"] =
        label: "Entries"
        data: flot_entries

    if flot_views
      datasets["view_count"] =
        label: "Views"
        data: flot_views

    for key, val of datasets
      data.push datasets[key]

    graphOptions = {
      series: {
        stack: true,
        lines: {
          show: true,
          fill: true,
          steps: false
        }
      },
      xaxis: {
        mode: "time",
        tickSize: [1, "day"],
        minTickSize: [1, "day"]
      },
      yaxis: {
        tickDecimals: 0,
        min: 0
      },
      grid: {
        clickable: true,
        hoverable: true
      },
      points: {
        show: true
      },
      colors: [ "#FAA732", "#5BB75B", "#49AFCD", "#111111" ]
    }

    plotWithOptions = ->
      $.plot($('.graph-placeholder'), data, graphOptions)

    plot = plotWithOptions()

    showTooltip = (x, y, contents) ->
      $("<div class='graph-tooltip'>#{contents}</div>").css(
        position: 'absolute'
        display: 'none'
        top: y + 12
        left: x + 12
      ).appendTo("body").stop().fadeIn(150)

    previousPoint = null

    canvasHover = ->
      plot.unhighlight()
      $(".graph-tooltip").remove()
      previousPoint = null

    itemHover = (item) ->
      if previousPoint != item.dataIndex
        previousPoint = item.dataIndex

        plot.unhighlight()
        $(".graph-tooltip").remove()

        plot.highlight(item.series, item.datapoint)

        x = new Date(item.datapoint[0])
        y = item.datapoint[1]

        showTooltip(item.pageX, item.pageY,
            "<span class='graph-tip-y'>" + y + " <span class='graph-tip-y-label' style='color:" + item.series.color + "'>" + item.series.label + "</span></span><br /><span class='graph-tip-x'><span class='graph-tip-x-val'>" + x.getMonth() + "/" + x.getDay() + "/" + x.getFullYear() + "</span></span>")

    plotHover = (event, pos, item) ->
      if item?
        itemHover(item)
      else
        canvasHover

    $(".graph-placeholder").bind("plothover", plotHover)