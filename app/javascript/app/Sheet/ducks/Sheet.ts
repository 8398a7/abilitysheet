import ActionReducer from 'action-reducer';
import { OrderedMap, Record } from 'immutable';
import { all, call, put, takeEvery } from 'redux-saga/effects';
import { RootState } from '.';
import { actions as metaActions } from '../../../lib/ducks/Meta';
import User from '../../../lib/models/User';
import { IModal } from '../../../lib/MyClient';
import MyClient from '../../../lib/MyClient';
import { PayloadAction } from '../../../types/action-reducer/index';
import { IScore } from '../models/Score';
import ScoreList from '../models/ScoreList';
import { ISheet } from '../models/Sheet';
import SheetList from '../models/SheetList';

export interface ISheetDefaultValue {
  user: User;
  sheetList: SheetList;
  scoreList: ScoreList;
  abilities: OrderedMap<number, string>;
  bp: string;
  filterName: string;
  selectDisplay: boolean;
  type: 'n_clear' | 'hard' | 'exh';
  versions: Array<[string, number]>;
  lamp: string[];
  recent: string;
  modal?: {
    title: string;
    textage: string;
    scores: Array<{ score: number | null, state: number | null, version: number, bp: number | null, updated_at: string }>;
  };
}
const defaultValue: ISheetDefaultValue = {
  user: new User(),
  sheetList: new SheetList(),
  scoreList: new ScoreList(),
  abilities: OrderedMap(),
  bp: localStorage.bp || '0',
  filterName: '',
  selectDisplay: true,
  type: 'n_clear',
  versions: [],
  lamp: [],
  recent: '',
  modal: undefined,
};
const initialRecord = Record(defaultValue);
export const initialState = new initialRecord();
const { reducer, createAction } = ActionReducer(initialState);
export default reducer;

const GET_USER_REQUESTED = 'sheet/getUserRequested';
const UPDATE_SCORE_REQUESTED = 'sheet/updateScoreRequested';
const GET_MODAL_REQUESTED = 'sheet/getModalRequested';
export const actions = {
  getUser: createAction(GET_USER_REQUESTED, ($$state, payload: { iidxid: string, type: RootState['$$sheet']['type'] }) => $$state.asImmutable()),
  toggleVersion: createAction('sheet/toggleVersion', ($$state, payload: number) => $$state.update('sheetList', sheetList => sheetList.toggleVersion(payload))),
  toggleLamp: createAction('sheet/toggleLamp', ($$state, payload: { state: number, status?: boolean }) => $$state.update('scoreList', scoreList => scoreList.toggleLamp(payload.state, payload.status))),
  reverseAbilities: createAction('sheet/reverseAbilities', $$state => $$state.update('abilities', abilities => abilities.reverse())),
  updateBp: createAction('sheet/updateBp', ($$state, payload: string) => {
    localStorage.bp = payload;
    return $$state.set('bp', payload);
  }),
  updateFilterName: createAction('sheet/updateFilterName', ($$state, payload: string) => $$state.set('filterName', payload)),
  updateScoreRequested: createAction(UPDATE_SCORE_REQUESTED, ($$state, payload: { iidxid: string, sheetId: number, state: number }) => $$state.asImmutable()),
  clickLink: createAction('sheet/clickLink', ($$state, payload: number) => $$state.asImmutable()),
  getModalRequested: createAction(GET_MODAL_REQUESTED, ($$state, payload: { iidxid: string, sheetId: number }) => $$state.asImmutable()),
  toggleDisplaySelect: createAction('sheet/toggleDisplaySelect', $$state => $$state.set('selectDisplay', !$$state.selectDisplay)),
};
const getUserFailed = createAction('sheet/getUserFailed', ($$state, error: Error) => $$state.asImmutable());
const updateSheetList = createAction('sheet/updateSheetList', ($$state, payload: ISheet[]) => $$state.update('sheetList', sheetList => sheetList.updateList(payload)));
const updateScoreList = createAction('sheet/updateScoreList', ($$state, payload: IScore[]) => $$state.update('scoreList', scoreList => scoreList.updateList(payload)));
const updateAbilities = createAction('sheet/updateAbilities', ($$state, payload: SagaCall<typeof client.getAbilities>['abilities']) => {
  let newAbilities = OrderedMap<number, string>();
  payload.forEach(ability => newAbilities = newAbilities.set(ability.key, ability.value));
  return $$state.set('abilities', newAbilities);
});
const updateScoreSucceeded = createAction('sheet/updateScoreSucceeded', ($$state, payload: IScore) => $$state.update('scoreList', scoreList => scoreList.updateScore(payload)));
const updateScoreFailed = createAction('sheet/updateScoreFailed', ($$state, error: Error) => $$state.asImmutable());
const getModalSucceeded = createAction('sheet/getModalSucceeded', ($$state, payload: IModal) => $$state.set('modal', payload));
const getModalFailed = createAction('sheet/getModalFailed', ($$state, error: Error) => $$state.asImmutable());

const client = new MyClient();
function* getUserRequested(action: PayloadAction<typeof actions.getUser>) {
  try {
    const { iidxid, type } = action.payload;
    const { abilitiesRes, sheetsRes }: {
      abilitiesRes: SagaCall<typeof client.getAbilities>;
      sheetsRes: SagaCall<typeof client.getSheets>;
    } = yield all({
      abilitiesRes: call(client.getAbilities, type),
      sheetsRes: call(client.getSheets),
    });
    yield put(updateAbilities(abilitiesRes.abilities));
    yield put(updateSheetList(sheetsRes.sheets));
    const { scores }: SagaCall<typeof client.getScores> = yield call(client.getScores, iidxid);
    yield put(updateScoreList(scores));
    yield put(metaActions.userMeRequested());
  } catch (error) {
    yield put(getUserFailed(error));
  }
}

function* updateScoreRequested(action: PayloadAction<typeof actions.updateScoreRequested>) {
  try {
    const { iidxid, sheetId, state } = action.payload;
    const newScore: SagaCall<typeof client.updateScore> = yield call(client.updateScore, iidxid, sheetId, state);
    yield put(updateScoreSucceeded(newScore));
  } catch (error) {
    yield put(updateScoreFailed(error));
  }
}

function* getModalRequested(action: PayloadAction<typeof actions.getModalRequested>) {
  try {
    const { iidxid, sheetId } = action.payload;
    const res: SagaCall<typeof client.getModal> = yield call(client.getModal, iidxid, sheetId);
    yield put(getModalSucceeded(res));
    (window as any).UIkit.modal('#sheet-modal').show();
  } catch (error) {
    yield put(getModalFailed(error));
  }
}

export function* sheetSaga() {
  yield takeEvery(GET_USER_REQUESTED, getUserRequested);
  yield takeEvery(UPDATE_SCORE_REQUESTED, updateScoreRequested);
  yield takeEvery(GET_MODAL_REQUESTED, getModalRequested);
}
