import * as React from 'react';
import { Provider } from 'react-redux';
import rootReducer, { rootSaga, RootState } from '../../lib/ducks';
import { actions, initialState } from '../../lib/ducks/Meta';
import storeCreator from '../../lib/store';
import Welcome from './components';

export default (props: AbilitysheetContext) => {
  const store = storeCreator<RootState>(props, rootReducer, rootSaga, { $$meta: initialState });
  store.dispatch(actions.userMeRequested());
  return (
    <Provider {...{ store }}>
      <Welcome />
    </Provider>
  );
};
