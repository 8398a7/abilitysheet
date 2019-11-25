import React from 'react';
import { Provider } from 'react-redux';
import rootReducer, { rootSaga, RootState } from '../../lib/ducks';
import { actions, initialState } from '../../lib/ducks/Meta';
import storeCreator from '../../lib/store';
import LogCalendar from './components';

export default (props: { iidxid: string } & AbilitysheetContext) => {
  const store = storeCreator<RootState>(props, rootReducer, rootSaga, {
    $$meta: initialState,
  });
  store.dispatch(actions.userMeRequested());
  const { iidxid } = props;
  return (
    <Provider {...{ store }}>
      <LogCalendar {...{ iidxid }} />
    </Provider>
  );
};
