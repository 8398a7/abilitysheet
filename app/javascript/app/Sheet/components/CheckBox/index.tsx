import React from 'react';
import { useSelector } from 'react-redux';
import { RootState } from '../../ducks';
import LampCheckbox from './LampCheckbox';
import VersionCheckbox from './VersionCheckbox';

const CheckBox: React.SFC = () => {
  const abilitiesSize = useSelector(
    (state: RootState) => state.$$sheet.abilities.size,
  );
  return (
    <>
      {abilitiesSize !== 0 ? <VersionCheckbox /> : null}
      <LampCheckbox />
    </>
  );
};

export default CheckBox;
