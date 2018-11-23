import * as React from 'react';

const RecentUpdate: React.SFC<{ recent?: string }> = (props) => {
  if (props.recent === undefined) { return null; }
  return (
    <a className="uk-button react" href={props.recent}>
      <i className="fa fa-refresh" />
      最近の更新
    </a>
  );
};

export default RecentUpdate;