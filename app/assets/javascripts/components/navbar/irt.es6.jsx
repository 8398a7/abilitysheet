class Irt extends React.Component {
  shouldComponentUpdate(nextProps, nextState) { return CheckComponentUpdate(this.props, nextProps, this.state, nextState) }

  render() {
    return (
      <li>
        <a href={recommends_path()}><i className='fa fa-level-up' />地力値表</a>
      </li>
    )
  }
}
