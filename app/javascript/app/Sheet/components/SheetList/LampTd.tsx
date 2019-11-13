import React from 'react';
import { useSelector } from 'react-redux';
import { RootState } from '../../ducks';
import Score from '../../models/Score';
import Sheet from '../../models/Sheet';
import LampSelect from './LampSelect';

const BpMark: React.SFC<{ bp: number; score?: Score }> = props => {
  const { bp, score } = props;
  if (Number.isNaN(bp)) {
    return null;
  }
  const scoreBp = score?.bp ?? -1;
  if (scoreBp < bp) {
    return null;
  }
  return <span> ★</span>;
};

interface IProps {
  sheet: Sheet;
  owner: boolean;
  score?: Score;
  width?: number;
  height?: number;
  updateLamp: (
    sheetId?: number,
  ) => (e: React.ChangeEvent<HTMLSelectElement>) => void;
  handleSheetClick: (sheetId?: number) => (e: React.MouseEvent) => void;
}

const LampTd: React.SFC<IProps> = props => {
  const $$env = useSelector((state: RootState) => state.$$meta.env);
  const bp = useSelector((state: RootState) => parseInt(state.$$sheet.bp, 10));
  const selectDisplay = useSelector(
    (state: RootState) => state.$$sheet.selectDisplay,
  );
  const filterName = useSelector(
    (state: RootState) => state.$$sheet.filterName,
  );
  const {
    width,
    height,
    sheet,
    score,
    owner,
    updateLamp,
    handleSheetClick,
  } = props;
  const { color } = $$env;
  let backgroundColor = color[color.length - 1];
  if (score?.state !== undefined) {
    backgroundColor = color[score.state];
  }
  let display = '';
  if (sheet.hide || score?.hide) {
    display = 'none';
  }
  if (
    filterName !== '' &&
    !sheet?.title?.toLowerCase().includes(filterName.toLowerCase())
  ) {
    display = 'none';
  }
  return (
    <td
      className="has-text-centered"
      style={{ width, height, backgroundColor, display }}
    >
      <a
        style={{ color: '#555555' }}
        href="#"
        onClick={handleSheetClick(sheet.id)}
      >
        {sheet.title}
        <BpMark {...{ bp, score }} />
      </a>
      <LampSelect
        {...{
          updateLamp,
          sheet_id: sheet.id,
          score,
          $$env,
          owner,
          selectDisplay,
        }}
      />
    </td>
  );
};

export default LampTd;
