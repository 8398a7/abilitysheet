import * as React from 'react';
import { Timeline } from 'react-twitter-widgets';
import TwitterSharedButton from '../../TwitterSharedButton';

const options = {
  height: 400,
};
const TwitterContents: React.SFC = () => (
  <div className="uk-grid">
    <div className="uk-width-medium-10-10">
      <TwitterSharedButton text="SP☆12参考表(地力表)支援サイト" />
    </div>
    <div className="uk-width-medium-5-10">
      <Timeline {...{ dataSource: { screenName: 'IIDX_12', sourceType: 'profile' }, options }} />
    </div>
    <div className="uk-width-medium-5-10">
      <Timeline {...{ dataSource: { screenName: 'IidxScoreTable', sourceType: 'profile' }, options }} />
    </div>
  </div>
);

export default TwitterContents;
