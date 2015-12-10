class @Message extends React.Component
  componentDidMount: ->
    return null unless @props.current_user
    return null if @props.message is 0
    if 75 <= @props.current_user.role
      $('.alert-message').addClass('uk-badge uk-badge-warning').append("<a href=#{admin_messages_path()}>未読メッセージ#{@props.message}件</a>")

  render: ->
    <div className="alert-message">
    </div>

Message.displayName = 'Message'
Message.propTypes =
  message: React.PropTypes.number
  current_user: React.PropTypes.object
