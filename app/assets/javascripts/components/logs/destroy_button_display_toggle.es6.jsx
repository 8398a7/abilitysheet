class DestroyButtonDisplayToggle extends React.Component {
  constructor(props) {
    super()
    this.state = {
      nonDisplay: true,
      display: false
    }
  }

  shouldComponentUpdate(nextProps, nextState) { return CheckComponentUpdate(this.props, nextProps, this.state, nextState) }

  toggleDisplay(type) {
    $('.destroy-button').each((index, elem) => type === 'display' ? $(elem).show() : $(elem).hide())
  }


  onClick(type) {
    this.toggleDisplay(type)
    switch (type) {
      case 'nonDisplay':
        this.setState({
          nonDisplay: true,
          display: false
        })
        break
      case 'display':
        this.setState({
          nonDisplay: false,
          display: true
        })
        break
    }
  }

  render() {
    return (
      <div className='uk-button-group' style={{marginBottom: '10px'}}>
        <button onClick={() => this.onClick('nonDisplay')} className={'uk-button uk-button-primary' + (this.state.nonDisplay ? ' uk-active' : '')}>非表示</button>
        <button onClick={() => this.onClick('display')} className={'uk-button uk-button-danger' + (this.state.display ? ' uk-active' : '')}>表示</button>
      </div>
    )
  }
}
