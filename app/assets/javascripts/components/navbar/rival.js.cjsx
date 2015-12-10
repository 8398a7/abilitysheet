class @Rival extends React.Component
  render: ->
    return null if @props.current_user? and @props.current_user.unmount?
    return null unless @props.current_user?
    <li className='uk-parent' data-uk-dropdown=''>
      <a><i className='fa fa-user-times' />ライバル</a>
      <div className='uk-dropdown uk-dropdown-navbar'>
        <ul className='uk-nav uk-nav-navbar'>
          <li><a href={list_rival_path()}>ライバル一覧</a></li>
          <li><a href={reverse_list_rival_path()}>逆ライバル一覧</a></li>
        </ul>
      </div>
    </li>
Rival.displayName = 'Rival'
Rival.propTypes =
  current_user: React.PropTypes.object
