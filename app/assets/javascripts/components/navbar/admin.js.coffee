@Admin = React.createClass
  displayName: 'Admin'

  propTypes:
    paths: React.PropTypes.object
    current_user: React.PropTypes.object

  componentDidMount: ->
    if 75 <= @props.current_user.role
      $('.admin-nav').append("<li><a href=#{@props.paths.admin_users}>ユーザ管理</a></li>")
      $('.admin-nav').append("<li><a href=#{@props.paths.admin_messages}>メッセージ管理</a></li>")
      $('.admin-nav').append("<li><a href=#{@props.paths.new_admin_mail}>問い合わせ返信</a></li>")
      $('.admin-nav').append("<li><a href=#{@props.paths.admin_sidekiq}>sidekiq管理</a></li>")
      $('.admin-nav').append("<li><a href=#{@props.paths.rails_admin}>RailsAdmin</a></li>")
    if @props.current_user.role is 100
      $('.admin-nav').append("<li><a href=#{@props.paths.new_admin_tweet}>Twitter</a></li>")

  render: ->
    if @props.current_user.role < 50
      return false
    <li className="uk-parent" data-uk-dropdown="">
      <a><i className="fa fa-gears"></i>管理</a>
      <div className="uk-dropdown uk-dropdown-navbar">
        <ul className="uk-nav uk-nav-navbar admin-nav">
          <li><a href={@props.paths.admin_sheets}>楽曲管理</a></li>
        </ul>
      </div>
    </li>
