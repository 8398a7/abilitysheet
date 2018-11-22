import * as React from 'react';
import { Provider } from 'react-redux';
import rootReducer, { rootSaga } from '../../lib/ducks';
import { actions } from '../../lib/ducks/Meta';
import storeCreator from '../../lib/store';
import LogCalendar from './components';

export default (props: { iidxid: string }) => {
  const store = storeCreator(props, rootReducer, rootSaga);
  store.dispatch(actions.userMeRequested());
  const { iidxid } = props;
  return (
    <Provider {...{ store }}>
      <LogCalendar {...{ iidxid }} />
    </Provider>
  );
};
