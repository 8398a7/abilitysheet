import * as React from 'react';

export default class TwitterContents extends React.Component<{}, {}> {
  public shouldComponentUpdate() { return false; }

  public componentDidMount() {
    if (typeof (window as any).twttr === 'undefined') {
      const twitterjs = document.createElement('script');
      twitterjs.async = true;
      twitterjs.src = '//platform.twitter.com/widgets.js';
      document.getElementsByTagName('body')[0].appendChild(twitterjs);
    } else {
      (window as any).twttr.widgets.load(document.getElementById('search-timeline'));
      (window as any).twttr.widgets.load(document.getElementById('owner-timeline'));
    }
    (window as any).widgetoon_main();
  }

  public render() {
    return (
      <div className="uk-grid">
        <div className="uk-width-medium-10-10">
          <a
            href="https://twitter.com/share"
            className="twitter-share-buttoon"
            data-url="https://iidx12.tk"
            data-text="SP☆12参考表(地力表)支援サイト"
            data-count="horizontal"
            data-size="large"
            data-lang="ja">ツイート</a>
        </div>
        <div className="uk-width-medium-5-10">
          <a id="search-timeline" className="twitter-timeline" data-widget-id="551580128916946944" href="https://twitter.com/search?q=iidx12.tk" />
        </div>
        <div className="uk-width-medium-5-10">
          <a id="owner-timeline" className="twitter-timeline" data-widget-id="602894937776988160" href="https://twitter.com/IIDX_12" />
        </div>
      </div>
    );
  }
}
