import React from 'react';
import { Provider } from 'react-redux';
import { initialState as metaInitialState } from '../../lib/ducks/Meta';
import { actions } from '../../lib/ducks/Meta';
import User, { IUser } from '../../lib/models/User';
import storeCreator from '../../lib/store';
import Sheet from './components';
import rootReducer, { rootSaga, RootState } from './ducks';
import { initialState as sheetInitialState, ISheetDefaultValue } from './ducks/Sheet';

interface ISheetProps {
  recent: ISheetDefaultValue['recent'];
  user: IUser;
  type: ISheetDefaultValue['type'];
  versions: ISheetDefaultValue['versions'];
  lamp: ISheetDefaultValue['lamp'];
}
export default (props: ISheetProps & AbilitysheetContext) => {
  const { recent, type, versions, lamp, user } = props;
  const initialState = {
    $$sheet: sheetInitialState
      .set('user', new User(user))
      .set('type', type)
      .set('versions', versions)
      .set('lamp', lamp)
      .set('recent', recent),
    $$meta: metaInitialState,
  };
  const store = storeCreator<RootState>(props, rootReducer, rootSaga, initialState);
  store.dispatch(actions.considerQueryString());
  return (
    <Provider {...{ store }}>
      <Sheet />
    </Provider>
  );
};
