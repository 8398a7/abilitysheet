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

const defaultValue: IUser = {
  id: -1,
  iidxid: '',
  role: 0,
  djname: '',
  grade: 0,
  pref: 0,
  image_url: '',
  created_at: '',
  follows: [],
  followers: [],
};

export default class User extends Record(defaultValue) {
  constructor(params?: Partial<IUser>) {
    params ? super(params) : super();
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
