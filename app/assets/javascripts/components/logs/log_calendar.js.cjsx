class @LogCalendar extends React.Component
  constructor: (props) ->
    super

  componentDidMount: ->
    UIkit.accordion $('.uk-accordion'),
      showfirst: false
    $('#log-calendar').fullCalendar
      lang: 'ja'

  render: ->
    <div className='uk-accordion' data-uk-accordion>
      <h3 className='uk-accordion-title center'>カレンダーで見る</h3>
      <div className='uk-accordion-content'>
        <div id='log-calendar' />
      </div>
    </div>
