import React from 'react';
import { Provider } from 'react-redux';
import rootReducer, { rootSaga, RootState } from '../../lib/ducks';
import { actions, initialState } from '../../lib/ducks/Meta';
import storeCreator from '../../lib/store';
import Adsenses from './Adsenses';

export default (props: { slot: 1 | 2 } & AbilitysheetContext) => {
  const store = storeCreator<RootState>(props, rootReducer, rootSaga, {
    $$meta: initialState,
  });
  store.dispatch(actions.considerQueryString());
  return (
    <Provider {...{ store }}>
      <Adsenses {...props} />
    </Provider>
  );
};
