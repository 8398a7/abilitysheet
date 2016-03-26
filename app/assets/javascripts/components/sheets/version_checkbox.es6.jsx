class VersionCheckbox extends React.Component {
  constructor(props) {
    super()
    this.state = {
      reverse: EnvironmentStore.findBy('reverseSheet')
    }
    this.onChangeReverseState = this.onChangeReverseState.bind(this)
    this.onChangeVersion = this.onChangeVersion.bind(this)
    this.onChangeReverse = this.onChangeReverse.bind(this)
  }

  shouldComponentUpdate(nextProps, nextState) {
    props = !Immutable.is(nextProps, this.props)
    state = !Immutable.is(nextState, this.state)
    return props || state
  }

  onChangeReverseState() {
    this.setState({reverse: EnvironmentStore.findBy('reverseSheet')})
  }

  componentWillMount() {
    EnvironmentStore.addChangeListener(this.onChangeReverseState)
  }

  componentWillUnmount() {
    EnvironmentStore.removeChangeListener(this.onChangeReverseState)
  }

  onChangeVersion(e) {
    e.target.checked ? SheetActionCreators.show(parseInt(e.target.value)) : SheetActionCreators.hide(parseInt(e.target.value))
    if (e.target.value !== '0') { return null }
    $('input[name="version-check"]').prop('checked', e.target.checked);
    $('input[name="version-check"]').each(index => {
      obj = $('input[name="version-check"]')[index]
      tmp = {}
      tmp.target = obj
      this.onChangeVersion(tmp)
    })
  }

  onChangeReverse() {
    params = getQueryParams(location.search)
    let url = location.origin + location.pathname
    // parameterの付与/削除
    this.state.reverse === true ? delete(params.reverse_sheet) : params.reverse_sheet = true
    history.replaceState('', '', mergeQueryParams(url, params))
    EnvironmentActionCreators.changeReverse(!this.state.reverse)
  }

  renderVersionCheckbox() {
    dom = []
    key = 1
    this.props.versions.forEach(version => {
      // ALLの時はnameを変えないと再帰し続ける
      if (version[1] === 0) {
        dom.push(<label key={'version-checkbox-' + key++}>
            <input type='checkbox' value={version[1]} name='all-version-check' defaultChecked={true} onChange={this.onChangeVersion} />
            {version[0]}
          </label>)
        return null
      }
      dom.push(<label key={'version-checkbox-' + key++}>
          <input type='checkbox' value={version[1]} name='version-check' defaultChecked={true} onChange={this.onChangeVersion} />
          {version[0]}
        </label>)
    })
    dom.push(<label key={'version-checkbox-' + key}>
        <input type='checkbox' value='0' name='reverse' checked={this.state.reverse} onChange={this.onChangeReverse} />
        逆順表示
      </label>)
    return dom
  }

  render() {
    return (
      <div className='version-checkbox'>
        {this.renderVersionCheckbox()}
      </div>
    )
  }
}

VersionCheckbox.propTypes = {
  versions: React.PropTypes.array.isRequired
}
