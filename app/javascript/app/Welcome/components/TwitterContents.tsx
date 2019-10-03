import React from 'react';
import { Timeline } from 'react-twitter-widgets';
import TwitterSharedButton from '../../TwitterSharedButton';

const options = {
  height: 400,
};
const TwitterContents: React.SFC = () => (
  <>
    <div>
      <TwitterSharedButton text="SP☆12参考表(地力表)支援サイト" />
    </div>
    <div className="columns">
      <div className="column">
        <Timeline
          {...{
            dataSource: { screenName: 'IIDX_12', sourceType: 'profile' },
            options,
          }}
        />
      </div>

      <div className="column">
        <Timeline
          {...{
            dataSource: { screenName: 'IidxScoreTable', sourceType: 'profile' },
            options,
          }}
        />
      </div>
    </div>
  </>
);

export default TwitterContents;
