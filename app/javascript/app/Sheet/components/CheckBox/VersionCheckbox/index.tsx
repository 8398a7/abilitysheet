import queryString from 'query-string';
import React, { FC, useCallback, useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators, Dispatch } from 'redux';
import { RootState } from '../../../ducks';
import { actions } from '../../../ducks/Sheet';
import Presentation from './presentation';

function mapStateToProps(state: RootState) {
  return {
    versions: state.$$sheet.versions,
  };
}
function mapDispatchToProps(dispatch: Dispatch) {
  const { toggleVersion, reverseAbilities } = actions;
  return bindActionCreators({ toggleVersion, reverseAbilities }, dispatch);
}
export type Props = ReturnType<typeof mapStateToProps> & ReturnType<typeof mapDispatchToProps>;

const VersionCheckbox: FC<Props> = ({ versions, toggleVersion, reverseAbilities }) => {
  const [reverse, setReverse] = useState(false);

  useEffect(() => {
    const query = queryString.parse(location.search);
    if (query.reverse_sheet === 'true') {
      handleChangeReverse();
    }
  }, []);

  const handleToggleVersion = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.value === '0') {
      versions.forEach(version => {
        const targetInput = document.querySelector<HTMLInputElement>(`input[name="version-check"][value="${version[1]}"]`);
        if (targetInput) {
          targetInput.checked = !targetInput.checked;
        }
        toggleVersion(version[1]);
      });
    } else {
      toggleVersion(parseInt(e.target.value, 10));
    }
  }, []);

  const handleChangeReverse = useCallback(() => {
    const query = queryString.parse(location.search);
    const url = location.origin + location.pathname;
    if (reverse === false && query.reverse_sheet === undefined) {
      history.replaceState('', '', `${url}?${queryString.stringify({ ...query, reverse_sheet: true })}`);
    } else if (reverse === true && query.reverse_sheet) {
      delete(query.reverse_sheet);
      history.replaceState('', '', `${url}?${queryString.stringify({ ...query })}`);
    }
    setReverse(!reverse);
    reverseAbilities();
  }, [reverse]);

  return (<Presentation {...{ versions, reverse, handleToggleVersion, handleChangeReverse }} />);
};

export default connect(mapStateToProps, mapDispatchToProps)(VersionCheckbox);
