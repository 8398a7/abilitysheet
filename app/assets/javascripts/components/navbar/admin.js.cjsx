@Admin = React.createClass
  displayName: 'Admin'

  propTypes:
    paths: React.PropTypes.object
    current_user: React.PropTypes.object

  componentDidMount: ->
    unless @props.current_user
      return
    if 50 <= @props.current_user.role
      $('.admin-parent').append('<a><i class="fa fa-gears"></i>&nbsp;管理</a><div class="uk-dropdown uk-dropdown-navbar"><ul class="uk-nav uk-nav-navbar admin-nav"></ul></div>')
      $('.admin-nav').append("<li><a href=#{@props.paths.admin_sheets}>楽曲管理</a></li>")
    if 75 <= @props.current_user.role
      $('.admin-nav').append("<li><a href=#{@props.paths.admin_users}>ユーザ管理</a></li>")
      $('.admin-nav').append("<li><a href=#{@props.paths.admin_messages}>メッセージ管理</a></li>")
      $('.admin-nav').append("<li><a href=#{@props.paths.new_admin_mail}>問い合わせ返信</a></li>")
      $('.admin-nav').append("<li><a href=#{@props.paths.admin_sidekiq}>sidekiq管理</a></li>")
      $('.admin-nav').append("<li><a href=#{@props.paths.rails_admin}>RailsAdmin</a></li>")
    if @props.current_user.role is 100
      $('.admin-nav').append("<li><a href=#{@props.paths.new_admin_tweet}>Twitter</a></li>")
      $('.admin-nav').append("<li><a href=#{@props.paths.admin_dashboards}>Dashboard</a></li>")

  render: ->
    unless @props.current_user?
      return false
    if @props.current_user.role < 50
      return false
    <li className="uk-parent admin-parent" data-uk-dropdown="">
    </li>
