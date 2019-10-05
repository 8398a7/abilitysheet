import React from 'react';
import { sheetPath } from '../../../lib/routes';
import { RootState } from '../ducks';

const mapping = {
  n_clear: {
    otherLinks: ['hard', 'exh'],
    buttons: ['is-danger', 'is-warning'],
  },
  hard: {
    otherLinks: ['clear', 'exh'],
    buttons: ['is-info', 'is-warning'],
  },
  exh: {
    otherLinks: ['clear', 'hard'],
    buttons: ['is-info', 'is-danger'],
  },
};
interface IProps {
  type: RootState['$$sheet']['type'];
  iidxid: string;
}
const OtherLinks: React.SFC<IProps> = props => {
  const { type, iidxid } = props;
  return (
    <div>
      <a
        className={`button ${mapping[type].buttons[0]}`}
        href={sheetPath(iidxid, mapping[type].otherLinks[0])}
      >
        {mapping[type].otherLinks[0].toUpperCase()}
      </a>
      <a
        className={`button ${mapping[type].buttons[1]}`}
        href={sheetPath(iidxid, mapping[type].otherLinks[1])}
      >
        {mapping[type].otherLinks[1].toUpperCase()}
      </a>
    </div>
  );
};

export default OtherLinks;
