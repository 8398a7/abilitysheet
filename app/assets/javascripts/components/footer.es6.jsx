class Footer extends BaseComponent {
  constructor(props) {
    super()
    this.state = {
      renderAds: UserStore.renderAds(),
      year: new Date().getFullYear()
    }
    this.onChangeCurrentUser = this.onChangeCurrentUser.bind(this)
  }

  onChangeCurrentUser() {
    this.setState({
      renderAds: UserStore.renderAds()
    })
  }

  componentWillMount() {
    UserStore.addChangeListener(this.onChangeCurrentUser)
  }

  componentWillUnmount() {
    UserStore.removeChangeListener(this.onChangeCurrentUser)
  }

  render() {
    return (
      <div className='footer'>
        {
          this.state.renderAds ?
            <RectangleAdsense
              client='ca-pub-5751776715932993'
              slot='9876188066'
              slot2='6503919265'
            /> : null
        }
        <div className='relative'>
          <div className='uk-panel panel-default'>
            <span className='left-position'>
              <a href='https://twitter.com/IIDX_12'>
                <i className='fa fa-twitter' />
                Twitter
              </a>
            </span>
            <span>
              &copy; IIDX☆12参考表 8398a7 2014-{this.state.year}
              &nbsp;
              <a href='https://github.com/8398a7/abilitysheet' target='_blank'>
                <i className='fa fa-github' />
              </a>
              &nbsp;
              <a href='https://slackin-abilitysheet.herokuapp.com'>
                <i className='fa fa-slack' />
              </a>
            </span>
          </div>
        </div>
      </div>
    )
  }
}
