class @CalHeatmap extends React.Component
  constructor: (props) ->
    super

  componentDidMount: ->
    cal = new CalHeatMap()
    startDate = new Date()
    range = 0
    if _ua.Mobile and @props.viewport
      range = 3
    else
      range = 12
    startDate.setMonth(startDate.getMonth() - (range - 1))
    cal.init
      domain: 'month'
      subDomain: 'day'
      data: "/api/v1/logs/cal-heatmap/#{@props.user.iidxid}?start={{d:start}}&stop={{d:end}}"
      start: startDate
      range: range
      tooltip: true
      cellSize: 9
      domainLabelFormat: '%Y-%m'

  render: ->
    <div className='uk-panel uk-panel-box'>
      <h3 className='uk-panel-title'>更新履歴</h3>
      <div id='cal-heatmap' />
    </div>

CalHeatmap.proptypes =
  user: React.PropTypes.object.isRequired
  viewport: React.PropTypes.bool.isRequired
