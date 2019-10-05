import React, { SFC, useCallback } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { RootState } from '../ducks/index';
import { actions } from '../ducks/Sheet';

interface IProps {
  color: RootState['$$meta']['env']['color'];
  modal: RootState['$$sheet']['modal'];
}

const Content: SFC<IProps> = ({ modal, color }) => {
  if (modal === undefined) {
    return null;
  }
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
  return <>{contents}</>;
};

const Textage = ({ modal }: { modal: IProps['modal'] }) => {
  if (modal === undefined) {
    return null;
  }
  if (!modal.textage) {
    return null;
  }
  return (
    <>
      <a
        key="textage-1p"
        href={modal.textage + '?1AC00'}
        target="_blank"
        className="button is-danger"
      >
        textage(1P)
      </a>
      <a
        key="textage-2p"
        href={modal.textage + '?2AC00'}
        target="_blank"
        className="button is-info"
      >
        textage(2P)
      </a>
    </>
  );
};

const Modal: SFC = () => {
  const color = useSelector((state: RootState) => state.$$meta.env.color);
  const modal = useSelector((state: RootState) => state.$$sheet.modal);
  const modalClass = useSelector(
    (state: RootState) => state.$$sheet.modalClass,
  );
  const dispatch = useDispatch();
  const handleCloseModal = useCallback(() => {
    dispatch(actions.closeModal());
  }, []);

  if (modal === undefined) {
    return null;
  }
  return (
    <div id="sheet-modal" className={modalClass} onClick={handleCloseModal}>
      <div className="modal-background" />
      <div className="modal-content">
        <div className="box">
          <h4 className="subtitle is-4">
            <i className="fa fa-history" />
            {modal.title}
          </h4>
          <table className="table is-striped is-fullwidth">
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
          <div className="has-text-centered">
            <Textage modal={modal} />
          </div>
          <button className="modal-close is-large" />
        </div>
      </div>
    </div>
  );
};

export default Modal;
