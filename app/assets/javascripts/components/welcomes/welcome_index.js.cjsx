class @WelcomeIndex extends React.Component
  constructor: (props) ->
    super
    @state =
      renderAds: UserStore.renderAds()
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
              { name: 'FC', y: 12.5, color: '#ff8c00' },
              { name: 'EXH', y: 12.5, color: '#ffd900' },
              { name: 'HARD', y: 12.5, color: '#ff6347' },
              { name: 'CLEAR', y: 12.5, color: '#afeeee' },
              { name: 'EASY', y: 12.5, color: '#98fb98' }
              { name: 'ASSIST', y: 12.5, color: '#9595ff' }
              { name: 'FAILED', y: 12.5, color: '#c0c0c0' }
              { name: 'NOPLAY', y: 12.5, color: '#ffffff' }
            ]
            center: [300, 60]
            size: 100
            showInLegend: false
            dataLabels:
                enabled: false
          }
        ]

  onChangeCurrentUser: =>
    @setState renderAds: UserStore.renderAds()

  componentWillMount: ->
    UserStore.addChangeListener(@onChangeCurrentUser)

  componentWillUnmount: ->
    UserStore.removeChangeListener(@onChangeCurrentUser)

  componentDidMount: ->
    new Highcharts.Chart @state.options

  render: ->
    <div className='welcome-index'>
      <TopPanel mobile={@props.mobile} />
      <hr style={margin: '10px 0'} />
      {
        <RectangleAdsense
          client='ca-pub-5751776715932993'
          slot='4549839260'
          slot2='3454772069'
          mobile={@props.mobile}
        /> if @state.renderAds
      }
      {<hr style={margin: '10px 0'} /> if @state.renderAds}
        <TwitterContents />
      <br />
      <div className='uk-panel uk-panel-box'>
        <h3 className='uk-panel-title'>可視化例</h3>
        <div className='center'>
          <div id='spline-graph' />
        </div>
      </div>
    </div>

WelcomeIndex.propTypes =
  mobile: React.PropTypes.bool.isRequired
