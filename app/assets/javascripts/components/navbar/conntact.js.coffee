@Conntact = React.createClass
  displayName: 'Conntact'

  propTypes:
    paths: React.PropTypes.object

  componentDidMount: ->

  render: ->
    <li>
      <a href={@props.paths.new_message}><i className="fa fa-phone"></i>連絡フォーム</a>
    </li>
