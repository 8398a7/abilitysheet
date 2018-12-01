import * as React from 'react';
import { connect } from 'react-redux';
import { RootState } from '../../ducks';
import LampCheckbox from './LampCheckbox';
import VersionCheckbox from './VersionCheckbox';

function mapStateToProps(state: RootState) {
  return {
    abilitiesSize: state.$$sheet.abilities.size,
  };
}
type Props = ReturnType<typeof mapStateToProps>;

const CheckBox: React.SFC<Props> = (props) => {
  return (
    <div className="checkbox">
      {props.abilitiesSize !== 0 ? <VersionCheckbox /> : null}
      <LampCheckbox />
    </div>
  );
};

export default connect(mapStateToProps)(CheckBox);
