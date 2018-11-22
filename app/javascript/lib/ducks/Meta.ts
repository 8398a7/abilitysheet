import ActionReducer from 'action-reducer';
import { Record } from 'immutable';
import { call, put, takeEvery } from 'redux-saga/effects';
import Environment from '../models/Environment';
import User, { IUser } from '../models/User';
import MyClient from '../MyClient';

const defaultValue = {
  env: new Environment(),
  currentUser: new User(),
};
const initialRecord = Record(defaultValue);
export const initialState = new initialRecord();
const { reducer, createAction } = ActionReducer(initialState);
export default reducer;

const USER_ME_REQUESTED = 'meta/userMeRequested';

const client = new MyClient();
export const actions = {
  userMeRequested: createAction(USER_ME_REQUESTED, $$state => $$state.asImmutable()),
  considerQueryString: createAction('meta/considerQueryString', $$state => $$state.update('env', env => env.considerQueryString())),
  toggleViewport: createAction('meta/toggleViewport', $$state => $$state.update('env', env => env.toggleViewport())),
};
const userMeSucceeded = createAction('meta/userMeSucceeded', ($$state, payload: IUser) => $$state.set('currentUser', new User(payload)));
const userMeFailed = createAction('meta/userMeFailed', ($$state, error: Error) => $$state.asImmutable());

function* userMeRequested() {
  try {
    const { current_user: user }: SagaCall<typeof client.getMe> = yield call(client.getMe);
    yield put(userMeSucceeded(user));
  } catch (error) {
    yield put(userMeFailed(error));
  }
}

export function* metaSaga() {
  yield takeEvery(USER_ME_REQUESTED, userMeRequested);
}
