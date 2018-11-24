import * as React from 'react';
// @ts-ignore
import Adsense from 'react-adsense';
import { connect } from 'react-redux';
import { RootState } from '../../lib/ducks';

function mapStateToProps(state: RootState) {
  const { client, slots } = state.$$meta.env.adsense;
  return {
    client,
    slots,
    mobile: state.$$meta.env.mobileView(),
    $$currentUser: state.$$meta.currentUser,
  };
}
interface IProps {
  slot: 1 | 2;
}
type Props = IProps & ReturnType<typeof mapStateToProps>;

class Adsenses extends React.Component<Props> {
  public render() {
    const { client, slots, $$currentUser } = this.props;
    const slot = slots[this.props.slot - 1];
    if ($$currentUser && !$$currentUser.renderAds()) { return null; }
    return (
      <div>
        <Adsense.Google
          {...{ client, slot }}
        />
      </div>
    );
  }
}

export default connect(mapStateToProps)(Adsenses);
