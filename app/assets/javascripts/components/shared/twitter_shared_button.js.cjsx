class @TwitterSharedButton extends React.Component
  constructor: (props) ->
    super
    @state =
      text: props.text
      display: 'none'

  componentDidMount: ->
    if twttr?
      twttr.widgets.load()
    else
      twitterjs = document.createElement 'script'
      twitterjs.async = true
      twitterjs.src = '//platform.twitter.com/widgets.js'
      document.getElementsByTagName('body')[0].appendChild twitterjs

  componentDidUpdate: ->
    @setState display: 'block'

  render: ->
    <a
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