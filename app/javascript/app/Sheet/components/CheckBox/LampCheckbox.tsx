import * as React from 'react';
import { connect } from 'react-redux';
import { bindActionCreators, Dispatch } from 'redux';
import { actions } from '../../ducks/Sheet';

function mapDispatchToProps(dispatch: Dispatch) {
  const { toggleLamp } = actions;
  return bindActionCreators({ toggleLamp }, dispatch);
}
interface IProps {
  lamp: string[];
}
type Props = IProps & ReturnType<typeof mapDispatchToProps>;
class LampCheckbox extends React.Component<Props> {
  public state = {
    clear: false,
    hard: false,
  };

  public handleMultipleChangeLamp = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { clear, hard } = this.state;
    switch (e.target.value) {
      case 'clear': {
        this.setState({ clear: !clear });
        [0, 1, 2, 3].forEach(state => {
          const dom = document.querySelector<HTMLInputElement>(`input#state-${state}`);
          if (dom) { dom.checked = clear; }
          this.props.toggleLamp({ state, status: !clear });
        });
        break;
      }
      case 'hard': {
        this.setState({ hard: !hard });
        [0, 1, 2].forEach(state => {
          const dom = document.querySelector<HTMLInputElement>(`input#state-${state}`);
          if (dom) { dom.checked = hard; }
          this.props.toggleLamp({ state, status: !hard });
        });
        break;
      }
    }
  }

  public handleChangeLamp = (e: React.ChangeEvent<HTMLInputElement>) => {
    this.props.toggleLamp({ state: parseInt(e.target.value, 10) });
  }

  public renderLampCheckbox() {
    let key = 0;
    const { clear, hard } = this.state;
    const dom = this.props.lamp.map(lamp => {
      const elem = (
        <label key={`lamp-checkbox-${key}`}>
          <input id={'state-' + key} type="checkbox" value={key} name="check-lamp" defaultChecked={true} onChange={this.handleChangeLamp} />
          {lamp}
        </label>
      );
      key += 1;
      return elem;
    });
    dom.push(<label key={'lamp-checkbox-clear'}>
        <input type="checkbox" value="hard" checked={hard} onChange={this.handleMultipleChangeLamp} />
        未難
      </label>);
    dom.push(<label key={'lamp-checkbox-hard'}>
        <input type="checkbox" value="clear" defaultChecked={clear} onChange={this.handleMultipleChangeLamp} />
        未クリア
      </label>);
    return dom;
  }

  public render() {
    return (
      <div className="lamp-checkbox">
        {this.renderLampCheckbox()}
      </div>
    );
  }
}

export default connect(null, mapDispatchToProps)(LampCheckbox);
