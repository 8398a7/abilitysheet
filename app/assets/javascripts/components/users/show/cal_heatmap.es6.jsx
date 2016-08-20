class CalHeatmap extends BaseComponent {
  constructor() {
    super()
    this.state = {
      items: null,
      date: null
    }
  }

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
      domainLabelFormat: '%Y-%m',
      onClick: (date, nb) => {
        this.setState({
          items: nb,
          date: `${date}`
        })
      }
    })
  }

  renderDetail() {
    if (!this.state.items) return null
    targetDate = new Date(this.state.date)
    text = `${targetDate.getFullYear()}-${('00' + (targetDate.getMonth() + 1)).substr(-2)}-${('00' + targetDate.getDate()).substr(-2)}`
    return (
      <div className='center'>
        <i className='fa fa-refresh' />
        <a href={logs_path(this.props.user.iidxid, text)}>{text}</a>の更新数は{this.state.items}個です
      </div>
    )
  }

  render() {
    return (
      <div className='uk-panel uk-panel-box'>
        <h3 className='uk-panel-title'>更新履歴</h3>
        <div id='cal-heatmap' />
        {this.renderDetail()}
      </div>
    )
  }
}

CalHeatmap.proptypes = {
  user: React.PropTypes.object.isRequired,
  viewport: React.PropTypes.bool.isRequired
}
