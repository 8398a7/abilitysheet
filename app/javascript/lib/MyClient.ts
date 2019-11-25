import axios from 'axios';
import { authenticityHeaders } from './Authenticity';
import {
  apiV1AbilitiesPath,
  apiV1ScorePath,
  apiV1SheetsPath,
  meApiV1UsersPath,
} from './routes';

axios.interceptors.request.use(
  config => {
    const newConfig = { ...config };
    newConfig.headers = authenticityHeaders();
    return newConfig;
  },
  error => Promise.reject(error),
);

interface IScore {
  sheet_id: number;
  title: string;
  state: number;
  score: number | null;
  bp: number | null;
  version: number;
  updated_at: string;
}
interface IUser {
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
interface ISheet {
  id: number;
  title: string;
  n_clear: number;
  n_clear_string: string;
  hard: number;
  hard_string: string;
  exh: number;
  exh_string: string;
  version: number;
}
interface IAbility {
  key: number;
  value: string;
}
export interface IModal {
  title: string;
  textage: string;
  scores: Array<{
    score: number | null;
    state: number | null;
    bp: number | null;
    version: number;
    updated_at: string;
  }>;
}
export interface ILog {
  state: number;
  title: string;
  created_date: string;
}

export default class MyClient {
  private ENDPOINT = `//${location.host}`;
  public getScores = (iidxid: string): Promise<{ scores: IScore[] }> =>
    this.sendGet(apiV1ScorePath(iidxid));
  public getSheets = (): Promise<{ sheets: ISheet[] }> =>
    this.sendGet(apiV1SheetsPath());
  public getMe = (): Promise<{ current_user: IUser }> =>
    this.sendGet(meApiV1UsersPath());
  public getGraph = (
    iidxid: string,
    year: string,
    month: string,
  ): Promise<{ [s: string]: any }> =>
    this.sendGet(`/api/v1/logs/graph/${iidxid}/${year}/${month}`);
  public getAbilities = (
    type: 'n_clear' | 'hard' | 'exh',
  ): Promise<{ abilities: IAbility[] }> =>
    this.sendGet(apiV1AbilitiesPath({ type }));
  public updateScore = (
    iidxid: string,
    sheetId: number,
    state: number,
  ): Promise<IScore> =>
    this.sendPut(`/api/v1/scores/${iidxid}/${sheetId}/${state}`);
  public getModal = (iidxid: string, sheetId: number): Promise<IModal> =>
    this.sendGet(`/api/v1/scores/${iidxid}/${sheetId}`);
  public getLogs = (
    iidxid: string,
    year: number,
    month: number,
  ): Promise<{ logs: ILog[] }> =>
    this.sendGet(`/api/v1/logs/${iidxid}/${year}/${month}`);
  private sendGet = (url: string) =>
    axios.get(this.ENDPOINT + url).then(response => response.data);
  private sendPut = (url: string) =>
    axios.put(this.ENDPOINT + url).then(response => response.data);
}
