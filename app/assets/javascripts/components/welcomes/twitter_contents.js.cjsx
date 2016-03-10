class @TwitterContents extends React.Component
  componentDidMount: ->
    if twttr?
      twttr.widgets.load $('#search-timeline')
      setTimeout ->
        twttr.widgets.load $('#owner-timeline')
      , 1000
    else
      twitterjs = document.createElement 'script'
      twitterjs.async = true
      twitterjs.src = '//platform.twitter.com/widgets.js'
      document.getElementsByTagName('body')[0].appendChild twitterjs

  render: ->
    <div className='uk-grid'>
      <div className='uk-width-medium-5-10'>
        <a id='search-timeline' className='twitter-timeline' data-widget-id='551580128916946944' href='https://twitter.com/search?q=iidx12.tk' />
      </div>
      <div className='uk-width-medium-5-10'>
        <a id='owner-timeline' className='twitter-timeline' data-widget-id='707837001911808000' href='https://twitter.com/search?q=%40IIDX_12' />
      </div>
    </div>
