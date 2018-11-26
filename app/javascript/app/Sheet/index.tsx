import * as React from 'react';
import { Provider } from 'react-redux';
import { actions } from '../../lib/ducks/Meta';
import { IUser } from '../../lib/models/User';
import storeCreator from '../../lib/store';
import Sheet from './components';
import rootReducer, { rootSaga } from './ducks';

interface ISheetProps {
  recent: string;
  user: IUser;
  type: 'n_clear' | 'hard' | 'exh';
  versions: Array<[string, number]>;
  sheet_type: number;
  lamp: string[];
}
export default (props: ISheetProps & AbilitysheetContext) => {
  const store = storeCreator(props, rootReducer, rootSaga);
  store.dispatch(actions.considerQueryString());
  const { recent, type, versions, lamp } = props;
  const { iidxid } = props.user;
  return (
    <Provider {...{ store }}>
      <Sheet {...{ recent, type, iidxid, versions, lamp }} />
    </Provider>
  );
};
