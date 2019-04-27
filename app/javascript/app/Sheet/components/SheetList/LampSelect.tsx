import React from 'react';
import Environment from '../../../../lib/models/Environment';
import Score from '../../models/Score';

interface IProps {
  updateLamp: (sheetId?: number) => (e: React.ChangeEvent<HTMLSelectElement>) => void;
  $$env: Environment;
  selectDisplay: boolean;
  owner: boolean;
  score?: Score;
  sheet_id?: number;
}
const LampSelect: React.SFC<IProps> = (props) => {
  const { sheet_id, updateLamp, selectDisplay, owner, $$env, score } = props;
  if (!owner) { return null; }
  let display = '';
  if (!selectDisplay) {
    display = 'none';
  }
  return (
    <form className="uk-form">
      <select id={`select_${sheet_id}`}
        onChange={updateLamp(sheet_id)}
        style={{ display, backgroundColor: (score && score.state !== undefined) ? $$env.color[score.state] : ''}}
        value={(score && score.state !== undefined) ? score.state : $$env.NOPLAY}
      >
        <option value={$$env.FC}>FC</option>
        <option value={$$env.EXH}>EXH</option>
        <option value={$$env.HARD}>H</option>
        <option value={$$env.CLEAR}>C</option>
        <option value={$$env.EASY}>E</option>
        <option value={$$env.ASSIST}>A</option>
        <option value={$$env.FAILED}>F</option>
        <option value={$$env.NOPLAY}>N</option>
      </select>
    </form>
  );
};

export default LampSelect;
