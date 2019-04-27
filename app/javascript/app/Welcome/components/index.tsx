import React from 'react';
import { connect } from 'react-redux';
import SplineGraph from '../../../lib/components/SplineGraph';
import { RootState } from '../../../lib/ducks';
import Adsenses from '../../Adsense/Adsenses';
import TopPanel from './TopPanel';
import TwitterContents from './TwitterContents';

function mapStateToProps(state: RootState) {
  return {
    $$currentUser: state.$$meta.currentUser,
    mobile: state.$$meta.env.mobileView(),
  };
}
type Props = ReturnType<typeof mapStateToProps>;
const Welcome: React.SFC<Props> = ({ $$currentUser: user, mobile }) => (
  <div>
    <TopPanel {...{ user, mobile }} />
    <Adsenses slot={1} />
    <div>
      SP ☆12以外を管理したい人向け: <a href="https://score.iidx12.tk" target="_blank">IIDX Score Table</a>
      <br />
      SP/DP両対応のスコア/ランプ管理アプリです。
    </div>
    <TwitterContents />
    <br />
    <div className="uk-panel uk-panel-box">
      <h3 className="uk-panel-title">可視化例</h3>
      <div className="center">
        <SplineGraph initialRender={true} />
      </div>
    </div>
  </div>
);

export default connect(mapStateToProps)(Welcome);
