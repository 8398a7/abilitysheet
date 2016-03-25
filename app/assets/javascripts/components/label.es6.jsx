class Label extends React.Component {
  async renderHoge() {
    console.log('hoge')
  }
  render () {
    this.renderHoge()
    return (
      <div>
        <div>Label: {this.props.label}</div>
      </div>
    );
  }
}

Label.propTypes = {
  label: React.PropTypes.string
};
