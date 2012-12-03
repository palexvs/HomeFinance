@LoadChart_1 = () ->
  chart = new Highcharts.Chart
    chart:
      renderTo: 'chart-container'
      type: 'line'
    title:
      text: 'Monthly Average Temperature'
    subtitle:
      text: 'Source: WorldClimate.com'
    xAxis:
      categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    yAxis:
      title:
        text: 'Temperature (°C)'
    tooltip:
      enabled: false
      formatter: () -> '<b>'+ this.series.name +'</b><br/>'+ this.x +': '+ this.y +'°C';
    plotOptions:
      line: 
        dataLabels:
          enabled: true
        enableMouseTracking: false
    series: [
      {name: 'Tokyo', data: [7.0, 6.9, 9.5, 14.5, 18.4, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]},
      {name: 'London', data: [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]}
    ]

@LoadChart = (data) ->
  data_series = []
  pointInterval = 24 * 3600 * 1000
  pointStart = Date.UTC(data.start_date[0],data.start_date[1]-1,data.start_date[2])
  for k,v of data.data
    data_series.push {
      name: k
      data: v
      pointStart: pointStart
      pointInterval: pointInterval
    }

  chart = new Highcharts.Chart
    chart:
      renderTo: 'chart-container'
      zoomType: 'x'
    title:
      text: 'Monthly Outlay'
    # subtitle:
    #   text: 'Source: WorldClimate.com'
    xAxis:
      type: 'datetime'
      maxZoom: 48 * 3600 * 1000
    yAxis:
      min: 0
      title:
        text: 'Amount'
    # tooltip:
    #   enabled: false
    #   formatter: () -> '<b>'+ this.series.name +'</b><br/>'+ this.x +': '+ this.y +'°C';
    # plotOptions:
    #   line: 
    #     dataLabels:
    #       enabled: true
    #     enableMouseTracking: false
    # series: [
    #   {name: 'Tokyo', data: [7.0, 6.9, 9.5, 14.5, 18.4, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]},
    #   {name: 'London', data: [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]}
    # ]    
    series: data_series
    # series: [
    #   { 
    #     name: 'Sum'
    #     data: data.data.sum
    #     pointStart: Date.UTC(data.start_date[0],data.start_date[1]-1,data.start_date[2])
    #     pointInterval: 24 * 3600 * 1000 },
    #   { 
    #     name: 'food'
    #     data: data.data.food
    #     pointStart: Date.UTC(data.start_date[0],data.start_date[1]-1,data.start_date[2])
    #     pointInterval: 24 * 3600 * 1000 }  
    # ]

@LoadChart_byWeek = (data) ->
  for id, arr_v of data.data
    arr_v.data_week = []
    arr_v.sum = 0
    for v, i in arr_v.value
      y = Math.floor(i/7)
      arr_v.data_week[y] = (arr_v.data_week[y] || 0) + v
      arr_v.sum += v

  data_series = []
  pointInterval = 7 * 24 * 3600 * 1000
  pointStart = Date.UTC(data.start_date[0],data.start_date[1]-1,data.start_date[2])

  for id, arr_v of data.data
    if arr_v.meta.depth == 0  
      data_series.push {
          name: arr_v.meta.name
          data: arr_v.data_week
          pointStart: pointStart
          pointInterval: pointInterval
          sum: arr_v.sum
        }
  data_series.sort (a, b) -> b.sum - a.sum

  chart = new Highcharts.Chart
    chart:
      renderTo: 'chart-container'
      zoomType: 'x'
    title:
      text: 'Outlay'
    # subtitle:
    #   text: 'Source: WorldClimate.com'
    xAxis:
      type: 'datetime'
      maxZoom: 7 * 24 * 3600 * 1000
    yAxis:
      min: 0
      title:
        text: 'Amount'
    # tooltip:
    #   enabled: false
    #   formatter: () -> '<b>'+ this.series.name +'</b><br/>'+ this.x +': '+ this.y +'°C';
    # plotOptions:
    #   line: 
    #     dataLabels:
    #       enabled: true
    #     enableMouseTracking: false
    # series: [
    #   {name: 'Tokyo', data: [7.0, 6.9, 9.5, 14.5, 18.4, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]},
    #   {name: 'London', data: [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]}
    # ] 
    series: data_series   
    # series: [
    #   { 
    #     name: 'Sum'
    #     data: data.data.sum
    #     pointStart: Date.UTC(data.start_date[0],data.start_date[1]-1,data.start_date[2])
    #     pointInterval: 7 * 24 * 3600 * 1000 },
    #   { 
    #     name: 'food'
    #     data: data.data.food
    #     pointStart: Date.UTC(data.start_date[0],data.start_date[1]-1,data.start_date[2])
    #     pointInterval: 7 * 24 * 3600 * 1000 }  
    # ]
    
@draw_chart_pie = (data, type) ->
  chart = new Highcharts.Chart
    chart:
      renderTo: "#{type}-round_month_chart-container"
      plotBackgroundColor: null
      plotBorderWidth: null
      plotShadow: false      
      zoomType: 'x'
    title:
      text: "#{type} (#{Highcharts.numberFormat(data.sum, 0, ',')})"
    tooltip: 
      pointFormat: '{series.name}: <b>{point.percentage}%</b> ({point.y})'
      percentageDecimals: 1
    plotOptions:
      pie:
        allowPointSelect: true
        cursor: 'pointer'
        dataLabels:
          enabled: true
          color: '#000000'
          connectorColor: '#000000'
          formatter: () -> 
            if this.percentage > 2
              "<b>#{this.point.name}</b>: #{Highcharts.numberFormat(this.percentage, 1, '.')}% (#{Highcharts.numberFormat(this.y,0,",")})"
            else
              null
    series: [{
      type: 'pie'
      name: "#{type}"
      data: data.data
    }]

@show_report_pie = ->
  data = $("#statistic_chart").data("statistic")
  
  data.outlay.sum = 0
  data.outlay.sum += v[1] for v in data.outlay.data

  data.income.sum = 0
  data.income.sum += v[1] for v in data.income.data

  balance = data.income.sum-data.outlay.sum

  draw_chart_pie({"data": [["Outlay", data.outlay.sum],["Left", balance]], "sum": balance}, 'balance')
  draw_chart_pie(data.outlay, 'outlay')
  draw_chart_pie(data.income, 'income')

@show_accounts_repost = ->
  data = $("#statistic_chart").data("statistic")
  
  [sdy,sdm,sdd] = data.start_date.split("-")
  start_date = Date.UTC(sdy,sdm-1,sdd)
  [fdy,fdm,fdd] = data.finish_date.split("-")
  finish_date = Date.UTC(fdy,fdm-1,fdd)

  accounts = {}
  
  for a in data.accounts
    a.data = []
    a.data[d] = 0 for d in [finish_date..start_date] by -86400000
    accounts[a.id] = a
  
  for t in data.transactions
    [dy,dm,dd] = t.date.split("-")
    t.date = Date.UTC(dy,dm-1,dd)
  
  data.transactions.sort (a, b) -> b.date - a.date
  
  for t in data.transactions
    switch t.type_id
      when 1
        accounts[t.account_id].data[t.date] += t.cents
      when 2
        accounts[t.account_id].data[t.date] -= t.cents
      when 3
        accounts[t.account_id].data[t.date] += t.cents
        accounts[t.t_account_id].data[t.date] -= t.t_cents
  
  for id,a of accounts
    data_arr = [[finish_date, a.cents]]
    min = 0
    for date,cents of a.data
      data_arr.push [parseInt(date), a.cents]
      a.cents += cents
      data_arr.push [parseInt(date), a.cents]
    data_arr.push [start_date, a.cents]

    container_id = "account_#{id}_chart-container"
    $('#main').append("<div id='#{container_id}'></div>")
    chart_area {
      container_id: container_id
      title: "Balance of '#{a.name} (#{a.currency_symbol})'"
      subtitle: "#{data.start_date} - #{data.finish_date}"
      currency: a.currency_symbol
      series: [ {name: a.name, data: data_arr.reverse()} ]
    }

@chart_area = (cfg) ->
  min = 0
  min = v for d,v of cfg.series when v < min
  chart = new Highcharts.Chart
    chart:
      renderTo: cfg.container_id
      type: 'area'
    title:
      text: cfg.title
    subtitle:
      text: cfg.subtitle
    xAxis:
      type: 'datetime'
    yAxis:
      title:
        text: cfg.currency
      labels: 
        formatter: () ->  Highcharts.numberFormat(@.value / 100,0,",")
      min: min
    tooltip:
      formatter: -> Highcharts.dateFormat('%Y-%m-%d', @.x) + ": <b>" + Highcharts.numberFormat(@.y / 100,0,",") + " #{cfg.currency} </b>"
    plotOptions:
      area:
        marker:
          enabled: false
          symbol: 'circle'
          radius: 2
          states:
            hover:
              enabled: true      
    series: cfg.series