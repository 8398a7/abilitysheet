class CalHeatmap extends BaseComponent {
  componentDidMount() {
    let cal = new CalHeatMap()
    let startDate = new Date()
    let range = _ua.Mobile && this.props.viewport ? 3 : 12
    startDate.setMonth(startDate.getMonth() - (range - 1))
    cal.init({
      domain: 'month',
      subDomain: 'day',
      data: `/api/v1/logs/cal-heatmap/${this.props.user.iidxid}?start={{d:start}}&stop={{d:end}}`,
      start: startDate,
      range: range,
      tooltip: true,
      cellSize: 9,
      domainLabelFormat: '%Y-%m'
    })
  }

  render() {
    return (
      <div className='uk-panel uk-panel-box'>
        <h3 className='uk-panel-title'>更新履歴</h3>
        <div id='cal-heatmap' />
      </div>
    )
  }
}

CalHeatmap.proptypes = {
  user: React.PropTypes.object.isRequired,
  viewport: React.PropTypes.bool.isRequired
}
