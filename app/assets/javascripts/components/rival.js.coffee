@Rival = React.createClass
  displayName: 'Rival'

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

#            li.uk-parent data-uk-dropdown=""
#              a = fa_icon 'user-times', text: 'ライバル'
#              .uk-dropdown.uk-dropdown-navbar
#                ul.uk-nav.uk-nav-navbar
#                  li = link_to 'ライバル一覧', list_rival_path
#                  li = link_to '逆ライバル一覧', reverse_list_rival_path
#
