@Conntact = React.createClass
  displayName: 'Conntact'

  propTypes:
    paths: React.PropTypes.object
    current_user: React.PropTypes.object

  componentDidMount: ->

  render: ->
    if @props.current_user is null
      return false
    <li>
      <a href={@props.paths.new_message}><i className="fa fa-phone"></i>連絡フォーム</a>
    </li>
