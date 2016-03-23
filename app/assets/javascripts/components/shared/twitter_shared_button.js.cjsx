class @TwitterSharedButton extends React.Component
  constructor: (props) ->
    super
    @state =
      text: props.text
      display: 'none'

  # 一度コンポーネントが描画されたら再描画は行わない
  shouldComponentUpdate: (nextProps, nextState) ->
    false

  componentDidMount: ->
    if twttr?
      twttr.widgets.load $('#twitter-shared-button')
    else
      twitterjs = document.createElement 'script'
      twitterjs.async = true
      twitterjs.src = '//platform.twitter.com/widgets.js'
      document.getElementsByTagName('body')[0].appendChild twitterjs

  componentDidUpdate: ->
    @setState display: 'block' if @state.display is 'none'

  render: ->
    <a
      id='twitter-shared-button'
      style={display: @state.display}
      href='https://twitter.com/share'
      data-text={@state.text}
      data-lang='ja'
      data-size='large'
      data-related='IIDX_12'
      className='twitter-share-button'
    >
      ツイート
    </a>

TwitterSharedButton.propTypes =
  text: React.PropTypes.string
