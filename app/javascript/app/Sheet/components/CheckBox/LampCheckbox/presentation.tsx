import React, { SFC, useMemo } from 'react';

interface IProps {
  lamp: string[];
  clear: boolean;
  hard: boolean;
  handleChangeLamp: (e: React.ChangeEvent<HTMLInputElement>) => void;
  handleClearChangeLamp: (e: React.ChangeEvent<HTMLInputElement>) => void;
  handleHardChangeLamp: (e: React.ChangeEvent<HTMLInputElement>) => void;
}
const Presentation: SFC<IProps> = props => {
  const {
    lamp,
    clear,
    hard,
    handleChangeLamp,
    handleClearChangeLamp,
    handleHardChangeLamp,
  } = props;
  const domList = useMemo(
    () =>
      lamp.map((l, idx) => (
        <span key={`lamp-checkbox-${idx}`}>
          <input
            id={`state-${idx}`}
            type="checkbox"
            value={idx}
            name="check-lamp"
            className="is-checkradio is-success is-circle"
            defaultChecked={true}
            onChange={handleChangeLamp}
          />
          <label htmlFor={`state-${idx}`}>{l}</label>
        </span>
      )),
    [lamp],
  );
  const constantDoms = useMemo(
    () => [
      <span key={'lamp-checkbox-clear'}>
        <input
          type="checkbox"
          value="hard"
          className="is-checkradio is-success is-circle"
          id="hard-checkbox"
          checked={hard}
          onChange={handleHardChangeLamp}
        />
        <label htmlFor="hard-checkbox">未難</label>
      </span>,
      <span key={'lamp-checkbox-hard'}>
        <input
          type="checkbox"
          value="clear"
          className="is-checkradio is-success is-circle"
          id="clear-checkbox"
          defaultChecked={clear}
          onChange={handleClearChangeLamp}
        />
        <label htmlFor="clear-checkbox">未クリア</label>
      </span>,
    ],
    [clear, hard],
  );

  return <div className="lamp-checkbox">{[...domList, ...constantDoms]}</div>;
};

export default Presentation;
