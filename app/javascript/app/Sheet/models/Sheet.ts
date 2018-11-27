import { Record } from 'immutable';

export interface ISheet {
  id: number;
  title: string;
  version: number;
  n_clear: number;
  n_clear_string: string;
  hard: number;
  hard_string: string;
  exh: number;
  exh_string: string;
  hide?: boolean;
}

const defaultValue: Partial<ISheet> = {
  id: undefined,
  title: undefined,
  version: undefined,
  n_clear: undefined,
  n_clear_string: undefined,
  hard: undefined,
  hard_string: undefined,
  exh: undefined,
  exh_string: undefined,
  hide: undefined,
};

export default class Sheet extends Record(defaultValue) {
  constructor(params?: Partial<ISheet>) {
    params ? super(params) : super();
  }
}
