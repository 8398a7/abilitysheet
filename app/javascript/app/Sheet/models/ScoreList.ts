import { Map, Record } from 'immutable';
import Score, { IScore } from './Score';

export interface IScoreList {
  list: Map<number, Score>;
  fetched: boolean;
}

const defaultValue: IScoreList = {
  list: Map(),
  fetched: false,
};

export default class ScoreList extends Record(defaultValue) {
  constructor(params?: Partial<IScoreList>) {
    params ? super(params) : super();
  }

  public toggleLamp(lamp: number, status?: boolean) {
    const newList = this.list.map(score => {
      if (score.state !== lamp) { return score; }
      const hide = status !== undefined ? status : !score.hide;
      return score.set('hide', hide);
    });
    return this.set('list', newList);
  }

  public updateList(params: IScore[]) {
    let newList = Map<number, Score>();
    params.forEach(score => {
      newList = newList.set(score.sheet_id, new Score(score));
    });
    return this.set('list', newList).set('fetched', true);
  }

  public updateScore(score: IScore) {
    return this.set('list', this.list.set(score.sheet_id, new Score(score)));
  }

  public findBySheetId(id: number | undefined) {
    if (id === undefined) { return; }
    return this.list.find(score => score.sheet_id === id);
  }

  public statistics() {
    const stat: { [n: number]: number } = {};
    this.list.forEach(score => {
      if (score.state === undefined) {
        if (stat[7] === undefined) { stat[7] = 0; }
        stat[7] += 1;
        return;
      }

      if (stat[score.state] === undefined) { stat[score.state] = 0; }
      stat[score.state] += 1;
    });

    return stat;
  }

  public noPlayCount(sheetCount: number) {
    let count = 0;
    this.list.forEach(score => {
      if (score.state === undefined) { return; }
      if ([0, 1, 2, 3, 4, 5, 6].indexOf(score.state) !== -1) { count += 1; }
    });
    return sheetCount - count;
  }

  public remainCount(type: 'n_clear' | 'hard' | 'exh', sheetCount: number) {
    let pattern: number[];
    switch (type) {
      case 'n_clear': {
        pattern = [0, 1, 2, 3];
        break;
      }
      case 'hard': {
        pattern = [0, 1, 2];
        break;
      }
      case 'exh': {
        pattern = [0, 1];
        break;
      }
    }

    let count = 0;
    this.list.forEach(score => {
      if (score.state === undefined) { return; }
      if (pattern.indexOf(score.state) !== -1) { count += 1; }
    });
    return sheetCount - count;
  }

  public completed(type: 'n_clear' | 'hard' | 'exh') {
    let count = 0;
    const stat = this.statistics();
    switch (type) {
      case 'n_clear': {
        [0, 1, 2, 3].forEach(num => {
          count += stat[num] || 0;
        });
        break;
      }
      case 'hard': {
        [0, 1, 2].forEach(num => {
          count += stat[num] || 0;
        });
        break;
      }
      case 'exh': {
        [0, 1].forEach(num => {
          count += stat[num] || 0;
        });
        break;
      }
    }
    return count;
  }
}
