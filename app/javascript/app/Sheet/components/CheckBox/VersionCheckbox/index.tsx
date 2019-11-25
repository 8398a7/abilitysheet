import queryString from 'query-string';
import React, { SFC, useCallback, useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';

import { RootState } from '../../../ducks';
import { actions } from '../../../ducks/Sheet';
import Presentation from './presentation';

const VersionCheckbox: SFC = () => {
  const dispatch = useDispatch();
  const versions = useSelector((state: RootState) => state.$$sheet.versions);

  const [reverse, setReverse] = useState(false);

  const handleChangeReverse = useCallback(() => {
    const query = queryString.parse(location.search);
    const url = location.origin + location.pathname;
    if (reverse === false && query.reverse_sheet === undefined) {
      history.replaceState(
        '',
        '',
        `${url}?${queryString.stringify({ ...query, reverse_sheet: true })}`,
      );
    } else if (reverse === true && query.reverse_sheet) {
      delete query.reverse_sheet;
      history.replaceState(
        '',
        '',
        `${url}?${queryString.stringify({ ...query })}`,
      );
    }
    setReverse(!reverse);
    dispatch(actions.reverseAbilities());
  }, [reverse]);

  useEffect(() => {
    const query = queryString.parse(location.search);
    if (query.reverse_sheet === 'true') {
      handleChangeReverse();
    }
  }, []);

  const handleToggleVersion = useCallback(
    (e: React.ChangeEvent<HTMLInputElement>) => {
      if (e.target.value === '0') {
        versions.forEach(version => {
          const targetInput = document.querySelector<HTMLInputElement>(
            `input[name="version-check"][value="${version[1]}"]`,
          );
          if (targetInput) {
            targetInput.checked = !targetInput.checked;
          }
          dispatch(actions.toggleVersion(version[1]));
        });
      } else {
        dispatch(actions.toggleVersion(parseInt(e.target.value, 10)));
      }
    },
    [],
  );

  return (
    <Presentation
      {...{ versions, reverse, handleToggleVersion, handleChangeReverse }}
    />
  );
};

export default VersionCheckbox;
