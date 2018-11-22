import * as React from 'react';
import { Provider } from 'react-redux';
import rootReducer, { rootSaga } from '../../lib/ducks';
import { actions } from '../../lib/ducks/Meta';
import User, { IUser } from '../../lib/models/User';
import storeCreator from '../../lib/store';
import Profile from './components/Profile';

export default (props: { user: IUser }) => {
  const store = storeCreator(props, rootReducer, rootSaga);
  store.dispatch(actions.considerQueryString());
  const user = new User(props.user);
  return (
    <Provider {...{ store }}>
      <Profile {...{ user }}/>
    </Provider>
  );
};
