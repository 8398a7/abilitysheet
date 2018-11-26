import * as React from 'react';
import { Provider } from 'react-redux';
import rootReducer, { rootSaga } from '../../lib/ducks';
import { actions } from '../../lib/ducks/Meta';
import storeCreator from '../../lib/store';
import Adsenses from './Adsenses';

export default (props: { slot: 1 | 2 } & AbilitysheetContext) => {
  const store = storeCreator(props, rootReducer, rootSaga);
  store.dispatch(actions.considerQueryString());
  return (
    <Provider {...{ store }}>
      <Adsenses {...props} />
    </Provider>
  );
};
