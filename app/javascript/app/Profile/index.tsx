import React from 'react';
import { Provider } from 'react-redux';
import rootReducer, { rootSaga, RootState } from '../../lib/ducks';
import { actions, initialState } from '../../lib/ducks/Meta';
import User, { IUser } from '../../lib/models/User';
import storeCreator from '../../lib/store';
import Profile from './components/Profile';

export default (props: { user: IUser } & AbilitysheetContext) => {
  const store = storeCreator<RootState>(props, rootReducer, rootSaga, {
    $$meta: initialState,
  });
  store.dispatch(actions.considerQueryString());
  const user = new User(props.user);
  return (
    <Provider {...{ store }}>
      <Profile {...{ user }} />
    </Provider>
  );
};
