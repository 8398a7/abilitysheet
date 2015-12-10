class @Admin extends React.Component
  componentDidMount: ->
    return unless @props.current_user
    if 50 <= @props.current_user.role
      $('.admin-parent').append('<a><i class="fa fa-gears"></i>&nbsp;管理</a><div class="uk-dropdown uk-dropdown-navbar"><ul class="uk-nav uk-nav-navbar admin-nav"></ul></div>')
      $('.admin-nav').append("<li><a href=#{admin_sheets_path()}>楽曲管理</a></li>")
    if 75 <= @props.current_user.role
      $('.admin-nav').append("<li><a href=#{admin_users_path()}>ユーザ管理</a></li>")
      $('.admin-nav').append("<li><a href=#{admin_messages_path()}>メッセージ管理</a></li>")
      $('.admin-nav').append("<li><a href=#{new_admin_mail_path()}>問い合わせ返信</a></li>")
      $('.admin-nav').append("<li><a href=#{admin_sidekiq_index_path()}>sidekiq管理</a></li>")
      $('.admin-nav').append("<li><a href='./admin/model'>RailsAdmin</a></li>")
    if @props.current_user.role is 100
      $('.admin-nav').append("<li><a href=#{new_admin_tweet_path()}>Twitter</a></li>")
      $('.admin-nav').append("<li><a href=#{admin_dashboards_path()}>Dashboard</a></li>")

  render: ->
    return null unless @props.current_user?
    return null if @props.current_user.role < 50
    <li className="uk-parent admin-parent" data-uk-dropdown="">
    </li>

Admin.displayName = 'Admin'
Admin.propTypes =
  current_user: React.PropTypes.object
