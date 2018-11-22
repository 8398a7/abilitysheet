import { combineReducers, Reducer } from 'redux';
import { fork } from 'redux-saga/effects';
import $$meta, { metaSaga } from '../../../lib/ducks/Meta';
import $$sheet, { sheetSaga } from './Sheet';

const rootState = combineReducers({ $$meta, $$sheet });
export default rootState;
export type RootState = typeof rootState extends Reducer<infer S> ? S : never;

export function* rootSaga() {
  yield fork(metaSaga);
  yield fork(sheetSaga);
}
