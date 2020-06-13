import { Map, Record } from 'immutable';
import Environment from '../../../lib/models/Environment';
import { RootState } from '../ducks';
import Score, { IScore } from './Score';

export interface IScoreList {
  list: Map<number, Score>;
  fetched: boolean;
  env: Environment;
}

const defaultValue: IScoreList = {
  list: Map(),
  fetched: false,
  env: new Environment(),
};

export default class ScoreList extends Record(defaultValue) {
  constructor(params?: Partial<IScoreList>) {
    params ? super(params) : super();
  }

  public toggleLamp(lamp: number, status?: boolean) {
    const newList = this.list.map((score) => {
      if (score.state !== lamp) {
        return score;
      }
      const hide = status ?? !score.hide;
      return score.set('hide', hide);
    });
    return this.set('list', newList);
  }

  public updateList(params: IScore[]) {
    let newList = Map<number, Score>();
    params.forEach((score) => {
      newList = newList.set(score.sheet_id, new Score(score));
    });
    return this.set('list', newList).set('fetched', true);
  }

  public updateScore(score: IScore) {
    let newScore = new Score(score);
    this.list.forEach((s) => {
      if (s.state === newScore.state) {
        newScore = newScore.set('hide', s.hide);
        return;
      }
    });
    return this.set('list', this.list.set(score.sheet_id, newScore));
  }

  public findBySheetId(id: number | undefined) {
    if (id === undefined) {
      return;
    }
    return this.list.find((score) => score.sheet_id === id);
  }

  public statistics() {
    const stat: { [n: number]: number } = {};
    this.list.forEach((score) => {
      if (score.state === undefined) {
        stat[7] = stat[7] ?? 0;
        stat[7] += 1;
        return;
      }

      stat[score.state] = stat[score.state] ?? 0;
      stat[score.state] += 1;
    });

    return stat;
  }

  public noPlayCount(sheetCount: number) {
    let count = 0;
    const { FC, EXH, HARD, CLEAR, EASY, ASSIST, FAILED } = this.env;
    this.list.forEach((score) => {
      if (score.state === undefined) {
        return;
      }
      if (
        [FC, EXH, HARD, CLEAR, EASY, ASSIST, FAILED].indexOf(score.state) !== -1
      ) {
        count += 1;
      }
    });
    return sheetCount - count;
  }

  public remainCount(type: RootState['$$sheet']['type'], sheetCount: number) {
    let pattern: number[];
    const { FC, EXH, HARD, CLEAR, EASY } = this.env;
    switch (type) {
      case 'n_clear': {
        pattern = [FC, EXH, HARD, CLEAR, EASY];
        break;
      }
      case 'hard': {
        pattern = [FC, EXH, HARD];
        break;
      }
      case 'exh': {
        pattern = [FC, EXH];
        break;
      }
    }

    let count = 0;
    this.list.forEach((score) => {
      if (score.state === undefined) {
        return;
      }
      if (pattern.indexOf(score.state) !== -1) {
        count += 1;
      }
    });
    return sheetCount - count;
  }

  public completed(type: RootState['$$sheet']['type']) {
    let count = 0;
    const { FC, EXH, HARD, CLEAR, EASY } = this.env;
    const stat = this.statistics();
    switch (type) {
      case 'n_clear': {
        [FC, EXH, HARD, CLEAR, EASY].forEach((num) => {
          count += stat[num] || 0;
        });
        break;
      }
      case 'hard': {
        [FC, EXH, HARD].forEach((num) => {
          count += stat[num] || 0;
        });
        break;
      }
      case 'exh': {
        [FC, EXH].forEach((num) => {
          count += stat[num] || 0;
        });
        break;
      }
    }
    return count;
  }
}
