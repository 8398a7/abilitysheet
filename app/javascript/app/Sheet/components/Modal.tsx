import React from 'react';
import { connect } from 'react-redux';
import { RootState } from '../ducks/index';

function mapStateToProps(state: RootState) {
  return {
    color: state.$$meta.env.color,
    modal: state.$$sheet.modal,
  };
}
type Props = ReturnType<typeof mapStateToProps>;
class Modal extends React.PureComponent<Props, {}> {
  public renderContent() {
    const { modal, color } = this.props;
    if (modal === undefined) { return; }
    return modal.scores.map(score => {
      return (
        <tr key={score.version}>
          <td style={{ backgroundColor: color[score.state || 7] }} />
          <td>{score.score}</td>
          <td>{score.bp}</td>
          <td>{score.version}</td>
          <td>{score.updated_at.split('T')[0]}</td>
        </tr>
      );
    });
  }

  public renderTextage() {
    const { modal } = this.props;
    if (modal === undefined) { return null; }
    if (!modal.textage) { return null; }
    const dom = [];
    dom.push(<a key="textage-1p" href={modal.textage + '?1AC00'} target="_blank" className="uk-button uk-button-danger">textage(1P)</a>);
    dom.push(<a key="textage-2p" href={modal.textage + '?2AC00'} target="_blank" className="uk-button uk-button-primary">textage(2P)</a>);
    return dom;
  }

  public render() {
    if (this.props.modal === undefined) { return null; }
    return (
      <div id="sheet-modal" className="uk-modal">
        <div className="uk-modal-dialog">
          <a className="uk-modal-close uk-close" />
          <div className="uk-modal-header">
            <h2><i className="fa fa-history" />{this.props.modal.title}</h2>
          </div>
          <table className="uk-table uk-table-hover uk-table-striped">
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
          <div className="uk-modal-footer center">
            {this.renderTextage()}
            <button className="uk-button uk-modal-close"><i className="fa fa-times" />Close</button>
          </div>
        </div>
      </div>
    );
  }
}

export default connect(mapStateToProps)(Modal);
