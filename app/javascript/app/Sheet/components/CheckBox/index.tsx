import * as React from 'react';
import LampCheckbox from './LampCheckbox';
import VersionCheckbox from './VersionCheckbox';

interface IProps {
  versions: Array<[string, number]>;
  type: 'n_clear' | 'hard' | 'exh';
  lamp: string[];
}

const CheckBox: React.SFC<IProps> = (props) => {
  const { versions, lamp } = props;
  return (
    <div className="checkbox">
      <VersionCheckbox {...{ versions }} />
      <LampCheckbox {...{ lamp }} />
    </div>
  );
};

export default CheckBox;
