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
    series: [
      { 
        name: 'Sum'
        data: data.data.sum
        pointStart: Date.UTC(data.start_date[0],data.start_date[1]-1,data.start_date[2])
        pointInterval: 24 * 3600 * 1000 },
      { 
        name: 'food'
        data: data.data.food
        pointStart: Date.UTC(data.start_date[0],data.start_date[1]-1,data.start_date[2])
        pointInterval: 24 * 3600 * 1000 }  
    ]

@LoadChart_byWeek = (data) ->
  sum_week = []
  food_week = []
  for v, i in data.data.sum
    w = Math.floor(i/7)
    sum_week[w] = (sum_week[w] || 0) + v
    food_week[w] = (food_week[w] || 0) + data.data.food[i]
  data.data.sum = sum_week
  data.data.food = food_week
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
    series: [
      { 
        name: 'Sum'
        data: data.data.sum
        pointStart: Date.UTC(data.start_date[0],data.start_date[1]-1,data.start_date[2])
        pointInterval: 7 * 24 * 3600 * 1000 },
      { 
        name: 'food'
        data: data.data.food
        pointStart: Date.UTC(data.start_date[0],data.start_date[1]-1,data.start_date[2])
        pointInterval: 7 * 24 * 3600 * 1000 }  
    ]
    
@Load_roundChart_month = (data) ->
  chart = new Highcharts.Chart
    chart:
      renderTo: 'round_month_chart-container'
      plotBackgroundColor: null
      plotBorderWidth: null
      plotShadow: false      
      zoomType: 'x'
    title:
      text: 'Outlay'
    tooltip: 
      pointFormat: '{series.name}: <b>{point.percentage}%</b>'
      percentageDecimals: 1
    plotOptions:
      pie:
        allowPointSelect: true
        cursor: 'pointer'
        dataLabels:
          enabled: true
          color: '#000000'
          connectorColor: '#000000'
          # formatter: () -> '<b>'+ this.point.name +'</b>: '+ this.percentage +' %'
    series: [{
      type: 'pie'
      name: 'Browser share'
      data: data.data
    }]
