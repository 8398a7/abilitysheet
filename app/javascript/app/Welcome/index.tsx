import * as React from 'react';
import { Provider } from 'react-redux';
import rootReducer, { rootSaga } from '../../lib/ducks';
import { actions } from '../../lib/ducks/Meta';
import storeCreator from '../../lib/store';
import Welcome from './components';

export default (props: AbilitysheetContext) => {
  const store = storeCreator(props, rootReducer, rootSaga);
  store.dispatch(actions.userMeRequested());
  return (
    <Provider {...{ store }}>
      <Welcome />
    </Provider>
  );
};
