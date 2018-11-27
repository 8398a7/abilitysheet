import { Record } from 'immutable';

export interface IScore {
  sheet_id: number;
  state: number;
  title: string;
  score: number | null;
  bp: number | null;
  version: number;
  updated_at: string;
  hide?: boolean;
}

const defaultValue: Partial<IScore> = {
  sheet_id: undefined,
  state: undefined,
  title: undefined,
  score: undefined,
  bp: undefined,
  version: undefined,
  updated_at: undefined,
  hide: undefined,
};

export default class Score extends Record(defaultValue) {
  constructor(params?: Partial<IScore>) {
    params ? super(params) : super();
  }

  public with(params: Partial<IScore>) {
    return this.merge(params);
  }
}
