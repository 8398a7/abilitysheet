import * as React from 'react';
import { Provider } from 'react-redux';
import { initialState as metaInitialState } from '../../lib/ducks/Meta';
import { actions } from '../../lib/ducks/Meta';
import { IUser } from '../../lib/models/User';
import storeCreator from '../../lib/store';
import Sheet from './components';
import rootReducer, { rootSaga, RootState } from './ducks';
import { initialState as sheetInitialState } from './ducks/Sheet';

interface ISheetProps {
  recent: string;
  user: IUser;
  type: 'n_clear' | 'hard' | 'exh';
  versions: Array<[string, number]>;
  sheet_type: number;
  lamp: string[];
}
export default (props: ISheetProps & AbilitysheetContext) => {
  const initialState = {
    $$sheet: sheetInitialState,
    $$meta: metaInitialState,
  };
  const store = storeCreator<RootState>(props, rootReducer, rootSaga, initialState);
  store.dispatch(actions.considerQueryString());
  const { recent, type, versions, lamp } = props;
  const { iidxid } = props.user;
  return (
    <Provider {...{ store }}>
      <Sheet {...{ recent, type, iidxid, versions, lamp }} />
    </Provider>
  );
};
