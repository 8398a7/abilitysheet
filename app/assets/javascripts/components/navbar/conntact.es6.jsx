class Conntact extends React.Component {
  shouldComponentUpdate(nextProps, nextState) { return CheckComponentUpdate(this.props, nextProps, this.state, nextState) }

  render() {
    return (
      <li>
        <a href={new_message_path()}><i className='fa fa-phone' />連絡フォーム</a>
      </li>
    )
  }
}
