import * as createRavenMiddleware from 'raven-for-redux';
import * as Raven from 'raven-js';
import { applyMiddleware, compose, createStore, Middleware, Reducer } from 'redux';
import { createLogger } from 'redux-logger';
import createSagaMiddleware, { SagaMiddleware } from 'redux-saga';

export default function storeCreator<T>(props: T & AbilitysheetContext, rootReducer: Reducer<any>, rootSaga?: any) {
  const middlewares: Middleware[] = [];
  if (process.env.NODE_ENV !== 'production') {
    middlewares.push(createLogger({
      stateTransformer: (state) => {
        const newState: any = {};
        for (const i of Object.keys(state)) { newState[i] = state[i].toJS(); }
        return newState;
      },
    }));
  }
  const devtools: any = process.env.NODE_ENV !== 'production' && (window as any).devToolsExtension ?
    (window as any).devToolsExtension() : (f: any) => f;

  const sagaMiddleware: SagaMiddleware<{}> = createSagaMiddleware();

  Raven.config(props.context.sentry_dsn).install();
  const store = createStore(
    rootReducer,
    compose(
      applyMiddleware(sagaMiddleware, createRavenMiddleware(Raven, {}), ...middlewares),
      devtools,
    ),
  );
  if (rootSaga) { sagaMiddleware.run(rootSaga); }

  return store;
}
