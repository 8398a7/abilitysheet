class @TwitterContents extends React.Component
  componentDidMount: ->
    @renderTwitter()

  renderTwitter: ->
    @loadTwitterSDK()
    $(document).on 'page:change', @renderTimelines

  loadTwitterSDK: ->
    $.getScript '//platform.twitter.com/widgets.js', => @renderTimelines()

  renderTimelines: ->
    $('.twitter-timeline-container').each ->
      container = $(@)
      widgetId = container.data 'widget-id'
      widgetOptions = container.data 'widget-options'
      container.empty()
      twttr?.widgets.createTimeline widgetId, container[0], null, widgetOptions

  render: ->
    <div className='uk-grid'>
      <div className='uk-width-medium-5-10'>
        <a className='twitter-timeline' data-widget-id='551580128916946944' href='https://twitter.com/search?q=iidx12' />
      </div>
      <div className='uk-width-medium-5-10'>
        <a className='twitter-timeline' data-widget-id='602894937776988160' href='https://twitter.com/IIDX_12' />
      </div>
    </div>
