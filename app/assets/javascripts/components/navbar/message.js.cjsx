@Message = React.createClass
  displayName: 'Message'

  propTypes:
    message: React.PropTypes.number
    current_user: React.PropTypes.object

  componentDidMount: ->
    unless @props.current_user
      return
    if @props.message is 0
      return
    if 75 <= @props.current_user.role
      $('.alert-message').addClass('uk-badge uk-badge-success').append("未読メッセージ#{@props.message}件")

  render: ->
    <div className="alert-message">
    </div>
