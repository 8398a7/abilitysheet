import React from 'react';
import { useSelector } from 'react-redux';

import { RootState } from '../../ducks';
import Score from '../../models/Score';
import Sheet from '../../models/Sheet';
import LampSelect from './LampSelect';
import { BelowBpMark, BpMark } from './BpMark';

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
        <BpMark {...{ score }} />
        <BelowBpMark {...{ score }} />
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
