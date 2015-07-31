@Conntact = React.createClass
  displayName: 'Conntact'

  propTypes:
    paths: React.PropTypes.object
    current_user: React.PropTypes.object

  componentDidMount: ->

  render: ->
    if @props.current_user is null
      return false
    <li className="uk-parent" data-uk-dropdown="">
      <a><i className="fa fa-database"></i>マイページ</a>
      <div className="uk-dropdown uk-dropdown-navbar">
        <ul className="uk-nav uk-nav-navbar">
          <li><a href={@props.paths.clear_sheet}>ノマゲ参考表</a></li>
          <li><a href={@props.paths.hard_sheet}>ハード参考表</a></li>
          <li><a href={@props.paths.power_sheet}>地力値参考表</a></li>
          <li><a href={@props.paths.logs_list}>更新データ</a></li>
          <li className="recent"></li>
        </ul>
      </div>
    </li>

#          li
#            = link_to new_message_path
#              = fa_icon 'phone', text: '連絡フォーム'
#
