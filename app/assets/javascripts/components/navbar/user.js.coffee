@User = React.createClass
  displayName: 'User'

  propTypes:
    paths: React.PropTypes.object
    current_user: React.PropTypes.object

  componentDidMount: ->
    unless @props.current_user
      $('.edit-user').append("<li><a href=#{@props.paths.clear_sheet}><i class='fa fa-sign-in'></i>ログイン</a></li>")
    else
      parent = $('.edit-user')
      $(parent).append("<li class='uk-parent' data-uk-dropdown=''><a><i class='fa fa-user'></i>#{@props.current_user.djname}</a>")
      $(parent).children('.uk-parent').append('<div class="uk-dropdown uk-dropdown-navbar">')
      $(parent).children('.uk-parent').children('.uk-dropdown').append('<ul class="uk-nav uk-nav-navbar">')
      $(parent).children('.uk-parent').children('.uk-dropdown').children('.uk-nav').append("<li><a href=#{@props.paths.edit_user}><i class='fa fa-pencil'></i>編集</a></li>")
      $(parent).children('.uk-parent').children('.uk-dropdown').children('.uk-nav').append("<li><a rel='nofollow' data-method='delete' href=#{@props.paths.sign_out}><i class='fa fa-sign-out'></i>ログアウト</a></li>")

  render: ->
    <ul className="uk-navbar-nav edit-user">
    </ul>
