import * as React from 'react';
import { Provider } from 'react-redux';
import rootReducer, { rootSaga } from '../../lib/ducks';
import { actions } from '../../lib/ducks/Meta';
import storeCreator from '../../lib/store';
import RectangleAdsense from './RectangleAdsense';

export default (props: {}) => {
  const store = storeCreator(props, rootReducer, rootSaga);
  store.dispatch(actions.considerQueryString());
  return (
    <Provider {...{ store }}>
      <RectangleAdsense />
    </Provider>
  );
};
