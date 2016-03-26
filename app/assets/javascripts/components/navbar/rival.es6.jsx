class Rival extends React.Component {
  shouldComponentUpdate(nextProps, nextState) {
    props = !Immutable.is(nextProps, this.props)
    state = !Immutable.is(nextState, this.state)
    return props || state
  }

  render() {
    if (!this.props.currentUser.id) { return null }
    return (
      <li className='uk-parent' data-uk-dropdown>
        <a><i className='fa fa-user-times' />ライバル</a>
        <div className='uk-dropdown uk-dropdown-navbar'>
          <ul className='uk-nav uk-nav-navbar'>
            <li><a href={list_rival_path()}>ライバル一覧</a></li>
            <li><a href={reverse_list_rival_path()}>逆ライバル一覧</a></li>
          </ul>
        </div>
      </li>
    )
  }
}

Rival.propTypes = {
  currentUser: React.PropTypes.object
}
