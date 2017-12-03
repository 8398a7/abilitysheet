class UserProfileRight extends BaseComponent {
  render() {
    return (
      <div className='uk-width-7-10'>
        <CalHeatmap user={this.props.user} viewport={this.props.viewport} />
        <SplineGraph initialRender={false} iidxid={this.props.user.iidxid} />
      </div>
    )
  }
}

UserProfileRight.proptypes = {
  user: PropTypes.object.isRequired,
  viewport: PropTypes.bool.isRequired
}
