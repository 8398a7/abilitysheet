import React from 'react';
// @ts-ignore
import Adsense from 'react-adsense';
import { useSelector } from 'react-redux';

import { RootState } from '../../lib/ducks';

const Adsenses: React.SFC<{ slot: 1 | 2 }> = (props) => {
  const { client, slots } = useSelector(
    (state: RootState) => state.$$meta.env.adsense,
  );
  const $$currentUser = useSelector(
    (state: RootState) => state.$$meta.currentUser,
  );

  const slot = slots[props.slot - 1];
  if ($$currentUser && !$$currentUser.renderAds()) {
    return null;
  }
  return (
    <div>
      <Adsense.Google
        {...{ client, slot }}
        style={{ display: 'block', backgroundColor: 'white' }}
      />
    </div>
  );
};

export default Adsenses;
