import * as Sentry from '@sentry/browser';
import {
  applyMiddleware,
  compose,
  createStore,
  Middleware,
  Reducer,
} from 'redux';
import { createLogger } from 'redux-logger';
import createSagaMiddleware, { SagaMiddleware } from 'redux-saga';
import { ForkEffect } from 'redux-saga/effects';
// @ts-ignore
import createSentryMiddleware from 'redux-sentry-middleware';

export default function storeCreator<S>(
  props: AbilitysheetContext,
  rootReducer: Reducer<any>,
  rootSaga: () => IterableIterator<ForkEffect>,
  initialState: S,
) {
  const middlewares: Middleware[] = [];
  if (process.env.NODE_ENV !== 'production') {
    middlewares.push(
      createLogger({
        stateTransformer: (state) => {
          const newState: any = {};
          for (const i of Object.keys(state)) {
            newState[i] = state[i].toJS();
          }
          return newState;
        },
      }),
    );
  }
  const devtools: any =
    process.env.NODE_ENV !== 'production' &&
    (window as any).__REDUX_DEVTOOLS_EXTENSION__
      ? (window as any).__REDUX_DEVTOOLS_EXTENSION__()
      : (f: any) => f;

  const sagaMiddleware: SagaMiddleware<{}> = createSagaMiddleware();

  const store = createStore(
    rootReducer,
    initialState,
    compose(
      applyMiddleware(
        sagaMiddleware,
        createSentryMiddleware(Sentry, {}),
        ...middlewares,
      ),
      devtools,
    ),
  );
  if (rootSaga) {
    sagaMiddleware.run(rootSaga);
  }

  return store;
}
