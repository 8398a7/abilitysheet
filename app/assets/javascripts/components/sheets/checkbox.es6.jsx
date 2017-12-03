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
  versions: PropTypes.array.isRequired,
  sheetType: PropTypes.number.isRequired,
  lamp: PropTypes.array.isRequired
}
