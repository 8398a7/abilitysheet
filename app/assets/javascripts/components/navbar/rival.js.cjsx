@Rival = React.createClass
  displayName: 'Rival'

  propTypes:
    paths: React.PropTypes.object
    current_user: React.PropTypes.object

  componentDidMount: ->

  render: ->
    unless @props.current_user?
      return false
    <li className="uk-parent" data-uk-dropdown="">
      <a><i className="fa fa-user-times"></i>&nbsp;ライバル</a>
      <div className="uk-dropdown uk-dropdown-navbar">
        <ul className="uk-nav uk-nav-navbar">
          <li><a href={@props.paths.rival_list}>ライバル一覧</a></li>
          <li><a href={@props.paths.reverse_rival_list}>逆ライバル一覧</a></li>
        </ul>
      </div>
    </li>
