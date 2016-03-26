class Checkbox extends React.Component {
  shouldComponentUpdate(nextProps, nextState) {
    props = !Immutable.is(nextProps, this.props)
    state = !Immutable.is(nextState, this.state)
    return props || state
  }

  render() {
    return (
      <div className='checkbox'>
        <VersionCheckbox versions={this.props.versions} />
        <LampCheckbox lamp={this.props.lamp} />
      </div>
    )
  }
}

Checkbox.propTypes = {
  versions: React.PropTypes.array.isRequired,
  sheetType: React.PropTypes.number.isRequired,
  lamp: React.PropTypes.array.isRequired
}
