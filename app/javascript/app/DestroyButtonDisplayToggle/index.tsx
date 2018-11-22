import * as React from 'react';

export default class DestroyButtonDisplayToggle extends React.PureComponent {
  public state = {
    nonDisplay: true,
    display: false,
  };

  public toggleDisplay(type: 'display' | 'nonDisplay') {
    document.querySelectorAll<HTMLButtonElement>('.destroy-button').forEach(elem => elem.style.display = type === 'display' ? '' : 'none');
  }

  public handleClick = (type: 'display' | 'nonDisplay') => () => {
    this.toggleDisplay(type);
    switch (type) {
      case 'nonDisplay':
        this.setState({ nonDisplay: true, display: false });
        break;
      case 'display':
        this.setState({ nonDisplay: false, display: true });
        break;
    }
  }

  public render() {
    return (
      <div className="uk-button-group" style={{marginBottom: '10px'}}>
        <button onClick={this.handleClick('nonDisplay')} className={'uk-button uk-button-primary' + (this.state.nonDisplay ? ' uk-active' : '')}>非表示</button>
        <button onClick={this.handleClick('display')} className={'uk-button uk-button-danger' + (this.state.display ? ' uk-active' : '')}>表示</button>
      </div>
    );
  }
}
