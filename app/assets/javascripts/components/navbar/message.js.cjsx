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

  render: ->
    MessageActionCreators.fetch() if 75 <= @props.current_user.role and @state.message is null
    return null if @state.message is 0 or @state.message is null
    <div className='uk-badge uk-badge-notification uk-badge-danger'>
      {@state.message}
    </div>

Message.propTypes =
  current_user: React.PropTypes.object
