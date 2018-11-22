import * as React from 'react';
import { connect } from 'react-redux';
import { RootState } from '../../lib/ducks';
import GoogleAdsenseIns from './GoogleAdsenseIns';

function mapStateToProps(state: RootState) {
  const { client, slot, slot2 } = state.$$meta.env.adsense;
  return {
    client,
    slot,
    slot2,
    mobile: state.$$meta.env.mobileView(),
    $$currentUser: state.$$meta.currentUser,
  };
}
type Props = ReturnType<typeof mapStateToProps>;

const style = {
  display: 'inline-block',
};
class RectangleAdsense extends React.PureComponent<Props, any> {
  public renderSecondRectangle() {
    const { mobile, client, slot2: slot } = this.props;
    if (mobile) { return null; }
    return (
      <GoogleAdsenseIns
        className="adslot_2"
        style={{ marginLeft: '20px', ...style }}
        {...{ client, slot }}
      />
    );
  }

  public render() {
    const { client, slot, $$currentUser } = this.props;
    if ($$currentUser && !$$currentUser.renderAds()) { return null; }
    return (
      <div className="rectangle-adsense">
        <p className="center">sponsored links</p>
        <GoogleAdsenseIns
          className="adslot_1"
          {...{ style, client, slot }}
        />
        {this.renderSecondRectangle()}
      </div>
    );
  }
}

export default connect(mapStateToProps)(RectangleAdsense);
