import { combineReducers, Reducer } from 'redux';
import { fork } from 'redux-saga/effects';
import $$meta, { metaSaga } from '../../lib/ducks/Meta';

const rootState = combineReducers({ $$meta });
export default rootState;
export type RootState = typeof rootState extends Reducer<infer S> ? S : never;

export function* rootSaga() {
  yield fork(metaSaga);
}
