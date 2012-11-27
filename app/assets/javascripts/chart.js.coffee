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
      text: 'Monthly Average Temperature'
    subtitle:
      text: 'Source: WorldClimate.com'
    xAxis:
      type: 'datetime'
      maxZoom: 48 * 3600 * 1000
    yAxis:
      title:
        text: 'Temperature (°C)'
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
    series: [{
        data: data,
        pointStart: Date.UTC(2010, 0, 1),
        pointInterval: 24 * 3600 * 1000
    }]    