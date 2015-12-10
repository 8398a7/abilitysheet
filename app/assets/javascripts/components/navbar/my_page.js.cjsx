class @MyPage extends React.Component
  recentDom: ->
    return if @props.recent is null
    <a href={@props.recent}>最近の更新</a>

  render: ->
    return null if @props.current_user is null
    <li className='uk-parent' data-uk-dropdown=''>
      <a><i className='fa fa-database' />マイページ</a>
      <div className='uk-dropdown uk-dropdown-navbar'>
        <ul className='uk-nav uk-nav-navbar'>
          <li><a href={sheet_path(@props.current_user.iidxid, type: 'clear')}>ノマゲ参考表</a></li>
          <li><a href={sheet_path(@props.current_user.iidxid, type: 'hard')}>ハード参考表</a></li>
          <li><a href={sheet_path(@props.current_user.iidxid, type: 'power')}>地力値参考表</a></li>
          <li><a href={list_log_path(@props.current_user.iidxid)}>更新データ</a></li>
          <li className='recent'>
            {@recentDom()}
          </li>
        </ul>
      </div>
    </li>
MyPage.displayName = 'MyPage'
MyPage.propTypes =
  current_user: React.PropTypes.object
  recent: React.PropTypes.string
