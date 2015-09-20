@Message = React.createClass
  displayName: 'Message'

  propTypes:
    message: React.PropTypes.number
    current_user: React.PropTypes.object
    paths: React.PropTypes.object

  componentDidMount: ->
    unless @props.current_user
      return
    if @props.message is 0
      return
    if 75 <= @props.current_user.role
      $('.alert-message').addClass('uk-badge uk-badge-warning').append("<a href=#{@props.paths.admin_messages}>未読メッセージ#{@props.message}件</a>")

  render: ->
    <div className="alert-message">
    </div>
