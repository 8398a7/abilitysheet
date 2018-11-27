import * as React from 'react';
import Environment from '../../../../lib/models/Environment';
import Score from '../../models/Score';
import Sheet from '../../models/Sheet';
import LampSelect from './LampSelect';

const BpMark: React.SFC<{ bp: number, score?: Score }> = (props) => {
  const { bp, score } = props;
  if (Number.isNaN(bp) || bp === 0) { return null; }
  if (score === undefined) { return null; }
  if (score.bp === null || score.bp === undefined) { return null; }

  if (score.bp < bp) { return null; }
  return (
    <span> ★</span>
  );
};

interface IProps {
  sheet: Sheet;
  width: number;
  height: number;
  $$env: Environment;
  bp: string;
  owner: boolean;
  selectDisplay: boolean;
  score?: Score;
  updateLamp: (sheetId?: number) => (e: React.ChangeEvent<HTMLSelectElement>) => void;
  handleSheetClick: (sheetId?: number) => () => void;
}
const LampTd: React.SFC<IProps> = (props) => {
  const { width, height, sheet, score, $$env, owner, updateLamp, handleSheetClick, selectDisplay } = props;
  const { color } = $$env;
  const bp = parseInt(props.bp, 10);
  let backgroundColor = color[color.length - 1];
  if (score && score.state !== undefined) {
    backgroundColor = color[score.state];
  }
  let display = '';
  if (sheet.hide || (score && score.hide)) {
    display = 'none';
  }
  return (
    <td style={{ width, height, backgroundColor, display }}>
      <a
        style={{ color: '#555555' }}
        href="#sheet-modal"
        data-uk-modal={true}
        onClick={handleSheetClick(sheet.id)}
      >
        {sheet.title}
        <BpMark {...{ bp, score }} />
      </a>
      <LampSelect {...{ updateLamp, sheet_id: sheet.id, score, $$env, owner, selectDisplay }} />
    </td>
  );
};

export default LampTd;
