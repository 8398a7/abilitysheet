import * as React from 'react';
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
    <hr style={{ margin: '10px 0' }} />
    <Adsenses slot={1} />
    {user.renderAds() ? <hr style={{ margin: '10px 0' }} /> : null}
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
