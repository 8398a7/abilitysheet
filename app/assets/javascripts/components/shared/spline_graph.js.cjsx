class @SplineGraph extends React.Component
  constructor: (props) ->
    super
    @state =
      options:
        chart:
          renderTo: 'spline-graph'
          defaultSeriesType: 'spline'
        title:
          text: '統計情報'
        xAxis:
          categories: ['2016-01', '2016-02', '2016-03']
        yAxis: [
          {
            allowDecimals: false
            title:
              text: '更新数'
            max: 40
            opposite: true
          },
          {
            allowDecimals: false
            title:
              text: '未達成数'
          }
        ]
        tooltip:
          shared: true
          crosshairs: true
        series: [
          { yAxis: 0, type: 'column', name: 'FC', data: [15, 10, 20], color: '#ff8c00' }
          { yAxis: 0, type: 'column', name: 'EXH', data: [30, 20, 22], color: '#ffd900' }
          { yAxis: 0, type: 'column', name: 'HARD', data: [40, 10, 33], color: '#ff6347' }
          { yAxis: 0, type: 'column', name: 'CLEAR', data: [5, 2, 1], color: '#afeeee' }
          { yAxis: 0, type: 'column', name: 'EASY', data: [3, 0, 0], color: '#98fb98' }
          { yAxis: 1, name: '未クリア', data: [20, 12, 11], color: '#afeeee' },
          { yAxis: 1, name: '未難', data: [80, 70, 47], color: '#ff6347' },
          { yAxis: 1, name: '未EXH', data: [60, 40, 18], color: '#ffd900' },
          { yAxis: 1, name: '未FC', data: [70, 60, 40], color: '#ff8c00' },
          {
            type: 'pie'
            name: 'クリア割合'
            data: [
              { name: 'FC', y: 10, color: '#ff8c00' },
              { name: 'EXH', y: 10, color: '#ffd900' },
              { name: 'HARD', y: 10, color: '#ff6347' },
              { name: 'CLEAR', y: 10, color: '#afeeee' },
              { name: 'EASY', y: 10, color: '#98fb98' }
              { name: 'ASSIST', y: 10, color: '#9595ff' }
              { name: 'FAILED', y: 10, color: '#c0c0c0' }
              { name: 'NOPLAY', y: 10, color: '#ffffff' }
            ]
            center: [300, 60]
            size: 100
            showInLegend: false
            dataLabels:
                enabled: false
          }
        ]

  componentDidMount: ->
    new Highcharts.Chart @state.options if @props.initialRender

  render: ->
    <div id='spline-graph' />

SplineGraph.propTypes =
  initialRender: React.PropTypes.bool.isRequired
