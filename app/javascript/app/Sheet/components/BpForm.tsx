import React, { useCallback } from 'react';
import { useSelector, useDispatch } from 'react-redux';

import { RootState } from '../ducks';
import { actions } from '../ducks/Sheet';

const BpForm: React.SFC = () => {
  const upperBp = useSelector((state: RootState) => state.$$sheet.upperBp);
  const belowBp = useSelector((state: RootState) => state.$$sheet.belowBp);

  const dispatch = useDispatch();
  const handleChangeUpperBp = useCallback(
    (e: React.ChangeEvent<HTMLInputElement>) => {
      dispatch(actions.updateUpperBp(e.target.value));
    },
    [],
  );
  const handleChangeBelowBp = useCallback(
    (e: React.ChangeEvent<HTMLInputElement>) => {
      dispatch(actions.updateBelowBp(e.target.value));
    },
    [],
  );

  return (
    <>
      <label className="label">指定したBP以上の曲に★マーク</label>
      <div className="control has-text-centered">
        <input
          className="input"
          type="text"
          value={upperBp}
          onChange={handleChangeUpperBp}
          style={{ width: '50%' }}
        />
      </div>
      <label className="label">指定したBP以下の曲に◆マーク</label>
      <div className="control has-text-centered">
        <input
          className="input"
          type="text"
          value={belowBp}
          onChange={handleChangeBelowBp}
          style={{ width: '50%' }}
        />
      </div>
    </>
  );
};

export default BpForm;
