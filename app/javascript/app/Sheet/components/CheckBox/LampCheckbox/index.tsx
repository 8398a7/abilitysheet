import React, { FunctionComponent, useCallback, useState } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators, Dispatch } from 'redux';
import { RootState } from '../../../ducks';
import { actions } from '../../../ducks/Sheet';
import Presentation from './presentation';

function mapStateToProps(state: RootState) {
  return {
    lamp: state.$$sheet.lamp,
    $$env: state.$$meta.env,
  };
}
function mapDispatchToProps(dispatch: Dispatch) {
  const { toggleLamp } = actions;
  return bindActionCreators({ toggleLamp }, dispatch);
}
export type Props = ReturnType<typeof mapStateToProps> & ReturnType<typeof mapDispatchToProps>;

const LampCheckbox: FunctionComponent<Props> = ({ $$env, lamp, toggleLamp }) => {
  const [clear, setClear] = useState(false);
  const [hard, setHard] = useState(false);

  const handleChangeLamp = useCallback(
    (e: React.ChangeEvent<HTMLInputElement>) => {
      toggleLamp({ state: parseInt(e.target.value, 10) });
    }, []);

  const handleMultipleChangeLamp = useCallback(
    (e: React.ChangeEvent<HTMLInputElement>) => {
      const { FC, EXH, HARD, CLEAR, EASY } = $$env;
      switch (e.target.value) {
        case 'clear': {
          setClear(!clear);
          [FC, EXH, HARD, CLEAR, EASY].forEach(state => {
            const d = document.querySelector<HTMLInputElement>(`input#state-${state}`);
            if (d) { d.checked = clear; }
            toggleLamp({ state, status: !clear });
          });
          break;
        }
        case 'hard': {
          setHard(!hard);
          [FC, EXH, HARD].forEach(state => {
            const d = document.querySelector<HTMLInputElement>(`input#state-${state}`);
            if (d) { d.checked = hard; }
            toggleLamp({ state, status: !hard });
          });
          break;
        }
      }
    },
    [clear, hard],
  );

  return (<Presentation {...{ lamp, clear, hard, handleChangeLamp, handleMultipleChangeLamp }} />);
};

export default connect(mapStateToProps, mapDispatchToProps)(LampCheckbox);
