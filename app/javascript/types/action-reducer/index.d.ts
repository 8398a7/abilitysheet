import { PayloadActionCreator } from 'action-reducer';

type PayloadAction<T> = T extends PayloadActionCreator<infer P>
  ? { type: string; payload: P }
  : never;
