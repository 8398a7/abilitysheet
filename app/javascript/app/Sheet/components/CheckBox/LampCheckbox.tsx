import React, { FunctionComponent, useCallback, useState } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators, Dispatch } from 'redux';
import { RootState } from '../../ducks';
import { actions } from '../../ducks/Sheet';

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
type Props = ReturnType<typeof mapStateToProps> & ReturnType<typeof mapDispatchToProps>;

const LampCheckbox: FunctionComponent<Props> = ({ $$env, lamp, toggleLamp }) => {
  const [clear, setClear] = useState(false);
  const [hard, setHard] = useState(false);

  const handleChangeLamp = (e: React.ChangeEvent<HTMLInputElement>) => {
    toggleLamp({ state: parseInt(e.target.value, 10) });
  };

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

  let key = 0;
  const dom = lamp.map(l => {
    const elem = (
      <label key={`lamp-checkbox-${key}`}>
        <input id={'state-' + key} type="checkbox" value={key} name="check-lamp" defaultChecked={true} onChange={handleChangeLamp} />
        {l}
      </label>
    );
    key += 1;
    return elem;
  });
  dom.push(<label key={'lamp-checkbox-clear'}>
      <input type="checkbox" value="hard" checked={hard} onChange={handleMultipleChangeLamp} />
      未難
    </label>);
  dom.push(<label key={'lamp-checkbox-hard'}>
      <input type="checkbox" value="clear" defaultChecked={clear} onChange={handleMultipleChangeLamp} />
      未クリア
    </label>);

  return (
    <div className="lamp-checkbox">
      {dom}
    </div>
  );
};

export default connect(mapStateToProps, mapDispatchToProps)(LampCheckbox);
