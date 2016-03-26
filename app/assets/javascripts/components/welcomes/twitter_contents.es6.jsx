class TwitterContents extends React.Component {
  shouldComponentUpdate(nextProps, nextState) { return false }

  componentDidMount() {
    if (typeof(twttr) === 'undefined') {
      twitterjs = document.createElement('script')
      twitterjs.async = true
      twitterjs.src = '//platform.twitter.com/widgets.js'
      document.getElementsByTagName('body')[0].appendChild(twitterjs)
    } else {
      twttr.widgets.load(document.getElementById('search-timeline'))
      twttr.widgets.load(document.getElementById('owner-timeline'))
    }
  }

  render() {
    return (
      <div className='uk-grid'>
        <div className='uk-width-medium-5-10'>
          <a id='search-timeline' className='twitter-timeline' data-widget-id='551580128916946944' href='https://twitter.com/search?q=iidx12.tk' />
        </div>
        <div className='uk-width-medium-5-10'>
          <a id='owner-timeline' className='twitter-timeline' data-widget-id='602894937776988160' href='https://twitter.com/IIDX_12' />
        </div>
      </div>
    )
  }
}
