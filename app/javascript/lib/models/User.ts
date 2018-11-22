import { Record } from 'immutable';

export interface IUser {
  id: number;
  iidxid: string;
  role: number;
  djname: string;
  grade: number;
  pref: number;
  image_url: string;
  created_at: string;
  follows: string[];
  followers: string[];
}

const defaultValue: Partial<IUser> = {
  id: undefined,
  iidxid: undefined,
  role: undefined,
  djname: undefined,
  grade: undefined,
  pref: undefined,
  image_url: undefined,
  created_at: undefined,
  follows: [],
  followers: [],
};

export default class User extends Record(defaultValue) {
  constructor(params?: Partial<IUser>) {
    params ? super(params) : super();
  }

  public with(params: Partial<IUser>) {
    return this.merge(params);
  }

  public renderAds() {
    if (this.role === undefined) { return true; }
    if (this.role >= 25) { return false; }
    return true;
  }

  public is(user: User) {
    return this.iidxid === user.iidxid;
  }
}
