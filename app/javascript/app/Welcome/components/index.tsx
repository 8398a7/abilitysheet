import React from 'react';
import { useSelector } from 'react-redux';
import SplineGraph from '../../../lib/components/SplineGraph';
import { RootState } from '../../../lib/ducks';
import Adsenses from '../../Adsense/Adsenses';
import TopPanel from './TopPanel';
import TwitterContents from './TwitterContents';

const Welcome: React.SFC = () => {
  const user = useSelector((state: RootState) => state.$$meta.currentUser);
  const mobile = useSelector((state: RootState) =>
    state.$$meta.env.mobileView(),
  );
  return (
    <>
      <TopPanel {...{ user, mobile }} />
      <Adsenses slot={1} />
      <div>
        SP ☆12以外を管理したい人向け:{' '}
        <a
          href="https://score.iidx.app"
          target="_blank"
          rel="noopener noreferrer"
        >
          IIDX Score Table
        </a>
        <br />
        SP/DP両対応のスコア/ランプ管理アプリです。
      </div>

      <TwitterContents />
      <br />
      <article className="message is-info">
        <div className="message-header">可視化例</div>
        <div className="message-body">
          <SplineGraph initialRender={true} />
        </div>
      </article>
    </>
  );
};

export default Welcome;
