class SheetModal extends React.Component {
  constructor(props) {
    super()
    this.state = {
      title: '',
      scores: []
    }
    this.onChangeModal = this.onChangeModal.bind(this)
  }

  onChangeModal() {
    this.setState(SheetModalStore.get())
  }

  componentWillMount() {
    SheetModalStore.addChangeListener(this.onChangeModal)
  }

  componentWillUnmount() {
    SheetModalStore.removeChangeListener(this.onChangeModal)
  }

  renderContent() {
    return this.state.scores.map(score => {
      return (
        <tr key={score.version}>
          <td style={{backgroundColor: Env.color[score.state]}}></td>
          <td>{score.score}</td>
          <td>{score.bp}</td>
          <td>{score.version}</td>
          <td>{score.updated_at.split('T')[0]}</td>
        </tr>
      )
    })
  }

  render() {
    return (
      <div id='sheet-modal' className='uk-modal'>
        <div className='uk-modal-dialog'>
          <a className='uk-modal-close uk-close'></a>
          <div className='uk-modal-header'>
            <h2><i className='fa fa-history' />{this.state.title}</h2>
          </div>
          <table className='uk-table uk-table-hover uk-table-striped'>
            <thead>
              <tr>
                <td>state</td>
                <td>score</td>
                <td>bp</td>
                <td>version</td>
                <td>updated at</td>
              </tr>
            </thead>
            <tbody>
              {this.renderContent()}
            </tbody>
          </table>
          <div className='uk-modal-footer center'>
            <button className='uk-button uk-button-danger uk-modal-close'>Close</button>
          </div>
        </div>
      </div>
    )
  }
}
