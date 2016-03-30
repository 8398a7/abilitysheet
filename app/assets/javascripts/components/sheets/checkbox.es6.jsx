class Checkbox extends BaseComponent {
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
