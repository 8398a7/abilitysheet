import { applyMiddleware, compose, createStore, Middleware, Reducer } from 'redux';
import { createLogger } from 'redux-logger';
import createSagaMiddleware, { SagaMiddleware } from 'redux-saga';

export default function storeCreator<T>(props: T, rootReducer: Reducer<any>, rootSaga?: any) {
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

  const store = createStore(
    rootReducer,
    compose(
      applyMiddleware(sagaMiddleware, ...middlewares),
      devtools,
    ),
  );
  if (rootSaga) { sagaMiddleware.run(rootSaga); }

  return store;
}
