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
    
@Load_roundChart_month = (data) ->
  sum = 0
  sum += v[1] for v in data.data

  chart = new Highcharts.Chart
    chart:
      renderTo: 'round_month_chart-container'
      plotBackgroundColor: null
      plotBorderWidth: null
      plotShadow: false      
      zoomType: 'x'
    title:
      text: "Outlay (#{Highcharts.numberFormat(sum, 0, ',')})"
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
      name: 'Outlay'
      data: data.data
    }]