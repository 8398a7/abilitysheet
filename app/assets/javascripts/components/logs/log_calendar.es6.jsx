class LogCalendar extends BaseComponent {
  constructor(props) {
    super()
    this.onChangeLogs = this.onChangeLogs.bind(this)
  }

  componentWillMount() {
    LogStore.addChangeListener(this.onChangeLogs)
    let today = new Date()
    LogActionCreators.get({iidxid: this.props.iidxid, year: today.getFullYear(), month: today.getMonth() + 1})
  }

  componentWillUnmount() {
    LogStore.removeChangeListener(this.onChangeLogs)
  }

  onChangeLogs() {
    let logs = LogStore.get()
    Object.keys(logs).forEach(date => {
      let log = logs[date]
      let event = {
        title: log.length + '個の更新',
        start: date,
        end: date,
        allDay: true,
        url: logs_path(this.props.iidxid, date),
        description: log.join('<br>')
      }
      $('#log-calendar').fullCalendar('renderEvent', event, false)
    })
  }

  componentDidMount() {
    UIkit.accordion($('.uk-accordion'), {showfirst: false})
    $('#log-calendar').fullCalendar({
      lang: 'ja',
      events: [],
      eventRender: (event, element) => {
        element.qtip({
          content: { text: event.description }
        })
      }
    })
    $('.fc-prev-button').on('click', () => this.onClickPrevNext())
    $('.fc-next-button').on('click', () => this.onClickPrevNext())
    $('.fc-today-button').on('click', () => this.onClickPrevNext())
  }

  onClickPrevNext() {
    let dates = $('.fc-left').text().replace(/年/g, '').replace('月', '').split(' ')
    LogActionCreators.get({iidxid: this.props.iidxid, year: dates[0], month: dates[1]})
  }

  render() {
    return (
      <div className='uk-accordion' data-uk-accordion>
        <h3 className='uk-accordion-title center'>カレンダーで見る</h3>
        <div className='uk-accordion-content'>
          <div id='log-calendar' />
        </div>
      </div>
    )
  }
}

LogCalendar.propTypes = {
  iidxid: React.PropTypes.string.isRequired
}
