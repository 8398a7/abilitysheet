@Admin = React.createClass
  displayName: 'Admin'

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

#          - if user_signed_in? && current_user.member?
#            li.uk-parent#nav-admin data-uk-dropdown=""
#              a = fa_icon 'gears', text: '管理'
#              .uk-dropdown.uk-dropdown-navbar
#                ul.uk-nav.uk-nav-navbar
#                  - if current_user.admin?
#                    li = link_to 'ユーザ管理', admin_users_path
#                    li = link_to 'メッセージ管理', admin_messages_path
#                    li = link_to '問い合わせ返信', new_admin_mail_path
#                    li = link_to 'siekiq管理', admin_sidekiq_index_path
#                    li = link_to  'RailsAdmin', rails_admin_path
#                  - if current_user.member?
#                    li = link_to '楽曲管理', admin_sheets_path
#                  - if current_user.owner?
#                    li = link_to 'Twitter', new_admin_tweet_path
