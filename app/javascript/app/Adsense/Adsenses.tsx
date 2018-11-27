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

const Adsenses: React.SFC<Props> = (props) => {
  const { client, slots, $$currentUser } = props;
  const slot = slots[props.slot - 1];
  if ($$currentUser && !$$currentUser.renderAds()) { return null; }
  return (
    <div>
      <Adsense.Google
        {...{ client, slot }}
        style={{ display: 'block', backgroundColor: 'white' }}
      />
    </div>
  );
};

export default connect(mapStateToProps)(Adsenses);
