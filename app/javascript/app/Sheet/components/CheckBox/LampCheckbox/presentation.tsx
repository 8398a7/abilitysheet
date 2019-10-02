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
        <label key={`lamp-checkbox-${idx}`}>
          <input
            id={'state-' + idx}
            type="checkbox"
            value={idx}
            name="check-lamp"
            defaultChecked={true}
            onChange={handleChangeLamp}
          />
          {l}
        </label>
      )),
    [lamp],
  );
  const constantDoms = useMemo(
    () => [
      <label key={'lamp-checkbox-clear'}>
        <input
          type="checkbox"
          value="hard"
          checked={hard}
          onChange={handleHardChangeLamp}
        />
        未難
      </label>,
      <label key={'lamp-checkbox-hard'}>
        <input
          type="checkbox"
          value="clear"
          defaultChecked={clear}
          onChange={handleClearChangeLamp}
        />
        未クリア
      </label>,
    ],
    [clear, hard],
  );

  return <div className="lamp-checkbox">{[...domList, ...constantDoms]}</div>;
};

export default Presentation;
