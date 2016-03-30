class LampTd extends BaseComponent {
  constructor(props) {
    super()
    this.state = {
      currentUser: UserStore.get()
    }
    this.onChangeCurrentUser = this.onChangeCurrentUser.bind(this)
    this.onClick = this.onClick.bind(this)
  }

  onChangeCurrentUser() {
    this.setState({currentUser: UserStore.get()})
  }

  componentWillMount() {
    UserStore.addChangeListener(this.onChangeCurrentUser)
  }

  componentWillUnmount() {
    UserStore.removeChangeListener(this.onChangeCurrentUser)
  }

  onClick(id) {
    SheetModalActionCreators.get({iidxid: this.props.iidxid, sheetId: id})
  }

  render() {
    if (!this.props.objects[this.props.index]) { return (<td style={{display: 'none'}} />) }
    return (
      <td
        width={this.props.width}
        height={this.props.height}
        style={{
          display: this.props.scores[this.props.index] ? this.props.scores[this.props.index].display : '',
          backgroundColor: this.props.scores[this.props.index] ? this.props.scores[this.props.index].color : ''
        }}
      >
        <a
          style={{color: '#555555'}}
          onClick={() => this.onClick(this.props.objects[this.props.index].id)}
          href='#sheet-modal'
          data-uk-modal
        >
          {this.props.objects[this.props.index].title}
        </a>
        {
          this.state.currentUser.iidxid === this.props.iidxid ?
            <LampSelect
              sheetId={parseInt(this.props.index)}
              display={this.props.display}
              score={this.props.scores[this.props.index]}
              iidxid={this.props.iidxid}
            /> : null
        }
      </td>
    )
  }
}

LampTd.propTypes = {
  objects: React.PropTypes.object.isRequired,
  index: React.PropTypes.string,
  scores: React.PropTypes.object.isRequired,
  display: React.PropTypes.string.isRequired,
  iidxid: React.PropTypes.string.isRequired,
  width: React.PropTypes.number,
  height: React.PropTypes.number
}
