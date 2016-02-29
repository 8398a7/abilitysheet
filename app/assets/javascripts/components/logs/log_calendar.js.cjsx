class @LogCalendar extends React.Component
  constructor: (props) ->
    super

  componentWillMount: ->
    LogStore.addChangeListener @onChangeLogs
    today = new Date()
    LogActionCreators.get iidxid: @props.iidxid, year: today.getFullYear(), month: today.getMonth() + 1

  componentWillUnmount: ->
    LogStore.removeChangeListener(@onChangeLogs)

  onChangeLogs: =>
    logs = LogStore.get()
    for date, log of logs
      event =
        title: "#{log.length}個の更新"
        start: date
        end: date
        allDay: true
        url: logs_path @props.iidxid, date
        description: log.join '<br>'
      $('#log-calendar').fullCalendar 'renderEvent', event, false

  componentDidMount: ->
    UIkit.accordion $('.uk-accordion'),
      showfirst: false
    $('#log-calendar').fullCalendar
      lang: 'ja'
      events: []
      eventRender: (event, element) ->
        element.qtip
          content:
            text: event.description
    $('.fc-prev-button').on 'click', =>
      @onClickPrevNext()
    $('.fc-next-button').on 'click', =>
      @onClickPrevNext()

  onClickPrevNext: ->
    dates = $('.fc-left').text().replace(/年/g, '').replace('月', '').split(' ')
    LogActionCreators.get iidxid: @props.iidxid, year: dates[0], month: dates[1]

  render: ->
    <div className='uk-accordion' data-uk-accordion>
      <h3 className='uk-accordion-title center'>カレンダーで見る</h3>
      <div className='uk-accordion-content'>
        <div id='log-calendar' />
      </div>
    </div>

LogCalendar.propTypes =
  iidxid: React.PropTypes.string.isRequired
