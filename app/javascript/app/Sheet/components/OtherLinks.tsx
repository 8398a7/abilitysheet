import * as React from 'react';

const mapping = {
  n_clear: {
    otherLinks: ['hard', 'exh'],
    buttons: ['uk-button-danger', 'uk-button-success'],
  },
  hard: {
    otherLinks: ['clear', 'exh'],
    buttons: ['uk-button-primary', 'uk-button-success'],
  },
  exh: {
    otherLinks: ['clear', 'hard'],
    buttons: ['uk-button-primary', 'uk-button-danger'],
  },
};
interface IProps {
  type: 'n_clear' | 'hard' | 'exh';
  iidxid?: string;
}
const OtherLinks: React.SFC<IProps> = (props) => {
  const { type, iidxid } = props;
  if (iidxid === undefined) { return null; }
  return (
    <div>
      <a className={`uk-button ${mapping[type].buttons[0]}`} href={(window as any).sheet_path({ iidxid, type: mapping[type].otherLinks[0] })}>
        {mapping[type].otherLinks[0].toUpperCase()}
      </a>
      <a className={`uk-button ${mapping[type].buttons[1]}`} href={(window as any).sheet_path({ iidxid, type: mapping[type].otherLinks[1] })}>
        {mapping[type].otherLinks[1].toUpperCase()}
      </a>
    </div>
  );
};

export default OtherLinks;
