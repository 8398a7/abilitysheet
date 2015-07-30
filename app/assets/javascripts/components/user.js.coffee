@User = React.createClass
  displayName: 'User'

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

#        .uk-navbar-flip.uk-hidden-small
#          ul.uk-navbar-nav
#            - if user_signed_in?
#              li.uk-parent data-uk-dropdown=""
#                a
#                  = fa_icon 'user', text: current_user.djname
#                .uk-dropdown.uk-dropdown-navbar
#                  ul.uk-nav.uk-nav-navbar
#                    li
#                      = link_to edit_user_registration_path
#                        = fa_icon 'pencil fw', text: '編集'
#                    li
#                      = link_to destroy_user_session_path, method: :delete
#                        = fa_icon 'sign-out fw', text: 'ログアウト'
#            - else
#              li
#                = link_to new_user_session_path
#                  = fa_icon 'sign-in', text: 'ログイン'
#
