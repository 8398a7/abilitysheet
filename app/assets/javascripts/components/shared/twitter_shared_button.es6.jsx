class TwitterSharedButton extends BaseComponent {
  constructor(props)  {
    super()
    this.state = {
      text: props.text,
      display: 'none'
    }
  }

  // 一度コンポーネントが描画されたら再描画は行わない
  shouldComponentUpdate(nextProps, nextState) { return false }

  componentDidMount() {
    if (typeof(twttr) === 'undefined') {
      twitterjs = document.createElement('script')
      twitterjs.async = true
      twitterjs.src = '//platform.twitter.com/widgets.js'
      document.getElementsByTagName('body')[0].appendChild(twitterjs)
    } else {
      twttr.widgets.load(document.getElementById('twitter-shared-button'))
    }
  }

  componentDidUpdate() {
    if (this.state.display !== 'none') {
      return null
    }
    this.setState({display: 'block'})
  }

  render() {
    return (
      <a
        id='twitter-shared-button'
        style={{display: this.state.display}}
        href='https://twitter.com/share'
        data-text={`${this.state.text} #iidx12`}
        data-lang='ja'
        data-size='large'
        data-related='IIDX_12'
        className='twitter-share-button'
      >
        ツイート
      </a>
    )
  }
}

TwitterSharedButton.propTypes = {
  text: PropTypes.string
}
