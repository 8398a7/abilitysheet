import React, { SFC, useCallback, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';

import { RootState } from '../../../ducks';
import { actions } from '../../../ducks/Sheet';
import Presentation from './presentation';

const LampCheckbox: SFC = () => {
  const dispatch = useDispatch();
  const lamp = useSelector((state: RootState) => state.$$sheet.lamp);
  const $$env = useSelector((state: RootState) => state.$$meta.env);
  const [clear, setClear] = useState(false);
  const [hard, setHard] = useState(false);

  const handleChangeLamp = useCallback(
    (e: React.ChangeEvent<HTMLInputElement>) => {
      dispatch(actions.toggleLamp({ state: parseInt(e.target.value, 10) }));
    },
    [lamp],
  );

  const handleClearChangeLamp = useCallback(() => {
    const { FC, EXH, HARD, CLEAR, EASY } = $$env;
    setClear(!clear);
    [FC, EXH, HARD, CLEAR, EASY].forEach((state) => {
      const d = document.querySelector<HTMLInputElement>(
        `input#state-${state}`,
      );
      if (d) {
        d.checked = clear;
      }
      dispatch(actions.toggleLamp({ state, status: !clear }));
    });
  }, [clear]);

  const handleHardChangeLamp = useCallback(() => {
    const { FC, EXH, HARD } = $$env;
    setHard(!hard);
    [FC, EXH, HARD].forEach((state) => {
      const d = document.querySelector<HTMLInputElement>(
        `input#state-${state}`,
      );
      if (d) {
        d.checked = hard;
      }
      dispatch(actions.toggleLamp({ state, status: !hard }));
    });
  }, [hard]);

  return (
    <Presentation
      {...{
        lamp,
        clear,
        hard,
        handleChangeLamp,
        handleClearChangeLamp,
        handleHardChangeLamp,
      }}
    />
  );
};

export default LampCheckbox;
