class RecentUpdate extends React.PureComponent {
  constructor(props) {
    super()
  }

  render() {
    if (this.props.recent === undefined) {
      return null
    }
    return (
      <a className='uk-button react' href={this.props.recent}>
        <i className='fa fa-refresh' />
        最近の更新
      </a>
    )
  }
}
