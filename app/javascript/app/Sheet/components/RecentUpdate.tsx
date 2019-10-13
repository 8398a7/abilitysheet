import React from 'react';

const RecentUpdate: React.SFC<{ recent: string }> = props => {
  return (
    <a className="button react" href={props.recent}>
      <i className="fa fa-sync" />
      最近の更新
    </a>
  );
};

export default RecentUpdate;
