import * as React from 'react';

export interface ITwitterSharedButton {
  text: string;
}
interface IState {
  text: string;
  display: string;
}
export default class TwitterSharedButton extends React.Component<ITwitterSharedButton, IState> {
  constructor(props: ITwitterSharedButton)  {
    super(props);
    this.state = {
      text: props.text,
      display: 'none'
    };
  }

  public shouldComponentUpdate() { return false; }

  public componentDidMount() {
    if (typeof((window as any).twttr) === 'undefined') {
      (window as any).twitterjs = document.createElement('script');
      (window as any).twitterjs.async = true;
      (window as any).twitterjs.src = '//platform.twitter.com/widgets.js';
      document.getElementsByTagName('body')[0].appendChild((window as any).twitterjs);
    } else {
      (window as any).twttr.widgets.load(document.getElementById('twitter-shared-button'));
    }
  }

  public componentDidUpdate() {
    if (this.state.display !== 'none') { return null; }
    this.setState({display: 'block'});
  }

  public render() {
    return (
      <a
        id="twitter-shared-button"
        style={{display: this.state.display}}
        href="https://twitter.com/share"
        data-text={`${this.state.text} #iidx12`}
        data-lang="ja"
        data-size="large"
        data-related="IIDX_12"
        className="twitter-share-button"
      >
        ツイート
      </a>
    );
  }
}
