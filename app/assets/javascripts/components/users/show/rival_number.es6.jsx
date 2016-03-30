class RivalNumber extends BaseComponent {
  render() {
    return (
      <table style={{margin: '0 auto', textAlign: 'center'}}>
        <tbody>
          <tr>
            <td><h2 id='rival-number'>{this.props.user.follows.length}</h2></td>
            <td><h2 id='reverse-rival-number'>{this.props.user.followers.length}</h2></td>
          </tr>
          <tr>
            <td>ライバル</td>
            <td>逆ライバル</td>
          </tr>
        </tbody>
      </table>
    )
  }
}

RivalNumber.proptypes = {
  user: React.PropTypes.object.isRequired
}
