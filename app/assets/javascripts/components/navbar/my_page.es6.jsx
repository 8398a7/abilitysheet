class MyPage extends React.Component {
  recentDom() {
    if (this.props.recent === null) { return null }
    return (<a href={this.props.recent}>最近の更新</a>)
  }

  render() {
    if (!this.props.currentUser.id) { return null }
    return (
      <li className='uk-parent' data-uk-dropdown=''>
        <a><i className='fa fa-database' />マイページ</a>
        <div className='uk-dropdown uk-dropdown-navbar'>
          <ul className='uk-nav uk-nav-navbar'>
            <li><a href={sheet_path(this.props.currentUser.iidxid, {type: 'clear'})}>ノマゲ参考表</a></li>
            <li><a href={sheet_path(this.props.currentUser.iidxid, {type: 'hard'})}>ハード参考表</a></li>
            <li><a href={sheet_path(this.props.currentUser.iidxid, {type: 'power'})}>地力値参考表</a></li>
            <li><a href={list_log_path(this.props.currentUser.iidxid)}>更新データ</a></li>
            <li className='recent'>
              {this.recentDom()}
            </li>
          </ul>
        </div>
      </li>
    )
  }
}

MyPage.propTypes = {
  currentUser: React.PropTypes.object,
  recent: React.PropTypes.string
}
