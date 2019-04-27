import React, { SFC } from 'react';
import { connect } from 'react-redux';
import { RootState } from '../ducks/index';

function mapStateToProps(state: RootState) {
  return {
    color: state.$$meta.env.color,
    modal: state.$$sheet.modal,
  };
}
type Props = ReturnType<typeof mapStateToProps>;

const Content: SFC<Props> = ({ modal, color }) => {
  if (modal === undefined) { return null; }
  const contents = modal.scores.map(score => {
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
  return (
    <>
      {contents}
    </>
  );
};

const Textage = ({ modal }: { modal: Props['modal'] }) => {
  if (modal === undefined) { return null; }
  if (!modal.textage) { return null; }
  return (
    <>
      <a key="textage-1p" href={modal.textage + '?1AC00'} target="_blank" className="uk-button uk-button-danger">textage(1P)</a>
      <a key="textage-2p" href={modal.textage + '?2AC00'} target="_blank" className="uk-button uk-button-primary">textage(2P)</a>
    </>
  );
};

const Modal: SFC<Props> = ({ color, modal }) => {
  if (modal === undefined) { return null; }
  return (
    <div id="sheet-modal" className="uk-modal">
      <div className="uk-modal-dialog">
        <a className="uk-modal-close uk-close" />
        <div className="uk-modal-header">
          <h2><i className="fa fa-history" />{modal.title}</h2>
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
            <Content {...{ color, modal }} />
          </tbody>
        </table>
        <div className="uk-modal-footer center">
          <Textage modal={modal} />
          <button className="uk-button uk-modal-close"><i className="fa fa-times" />Close</button>
        </div>
      </div>
    </div>
  );
};

export default connect(mapStateToProps)(Modal);
