import * as React from 'react';
import LampCheckbox from './LampCheckbox';
import VersionCheckbox from './VersionCheckbox';

const CheckBox: React.SFC = () => {
  return (
    <div className="checkbox">
      <VersionCheckbox />
      <LampCheckbox />
    </div>
  );
};

export default CheckBox;
