class @Message extends React.Component
  constructor: (props) ->
    @state =
      message: null

  componentDidMount: ->
    MessageStore.addChangeListener(@onChangeMessage)

  componentWillUnmount: ->
    MessageStore.removeChangeListener(@onChangeMessage)

  onChangeMessage: =>
    @setState message: MessageStore.get()

  componentDidUpdate: ->
    MessageActionCreators.fetch() if @props.current_user? and 75 <= @props.current_user.role and @state.message is null

  render: ->
    return null if @state.message is 0 or @state.message is null
    <div className='uk-badge uk-badge-notification uk-badge-danger'>
      {@state.message}
    </div>

Message.displayName = 'Message'
Message.propTypes =
  current_user: React.PropTypes.object
