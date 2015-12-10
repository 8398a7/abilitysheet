class @User extends React.Component
  componentDidMount: ->
    unless @props.current_user
      $('.edit-user').append("<li><a href=#{new_user_session_path()}><i class='fa fa-sign-in'></i>&nbsp;ログイン</a></li>")
    else
      parent = $('.edit-user')
      $(parent).append("<li class='uk-parent' data-uk-dropdown=''><a><i class='fa fa-user'></i>&nbsp;#{@props.current_user.djname}</a>")
      $(parent).children('.uk-parent').append('<div class="uk-dropdown uk-dropdown-navbar">')
      $(parent).children('.uk-parent').children('.uk-dropdown').append('<ul class="uk-nav uk-nav-navbar">')
      $(parent).children('.uk-parent').children('.uk-dropdown').children('.uk-nav').append("<li><a href=#{edit_user_registration_path()}><i class='fa fa-pencil'></i>編集</a></li>")
      $(parent).children('.uk-parent').children('.uk-dropdown').children('.uk-nav').append("<li><a rel='nofollow' data-method='delete' href=#{destroy_user_session_path()}><i class='fa fa-sign-out'></i>ログアウト</a></li>")

  render: ->
    <ul className="uk-navbar-nav edit-user">
    </ul>
User.displayName = 'User'
User.propTypes =
  current_user: React.PropTypes.object
