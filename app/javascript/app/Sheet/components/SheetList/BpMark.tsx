import React from 'react';
import { useSelector } from 'react-redux';

import Score from '../../models/Score';
import { RootState } from '../../ducks/index';

export const BpMark: React.SFC<{ score?: Score }> = ({ score }) => {
  const bp = useSelector((state: RootState) => parseInt(state.$$sheet.bp, 10));
  if (Number.isNaN(bp) || bp === 0) {
    return null;
  }
  if (score?.bp == null || score.bp < bp) {
    return null;
  }
  return <span> ★</span>;
};

export const BelowBpMark: React.SFC<{ score?: Score }> = ({ score }) => {
  const bp = useSelector((state: RootState) =>
    parseInt(state.$$sheet.belowBp, 10),
  );
  if (Number.isNaN(bp) || bp === 0) {
    return null;
  }
  if (score?.bp == null || score.bp > bp) {
    return null;
  }
  return <span> ◆</span>;
};
