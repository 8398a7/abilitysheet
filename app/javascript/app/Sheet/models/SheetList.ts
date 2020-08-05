import { Map, Range, Record } from 'immutable';
import { RootState } from '../ducks';
import Sheet, { ISheet } from './Sheet';

export interface ISheetList {
  list: Map<number, Sheet>;
}

const defaultValue: ISheetList = {
  list: Map(),
};

export default class SheetList extends Record(defaultValue) {
  constructor(params?: Partial<ISheetList>) {
    params ? super(params) : super();
  }

  public toggleVersion(version: number) {
    const newList = this.list.map((sheet) => {
      if (sheet.version !== version) {
        return sheet;
      }
      return sheet.set('hide', !sheet.hide);
    });
    return this.set('list', newList);
  }

  public updateList(params: ISheet[]) {
    let newList = Map<number, Sheet>();
    params.forEach((sheet) => {
      newList = newList.set(sheet.id, new Sheet(sheet));
    });
    return this.set('list', newList);
  }

  public whereAbility(ability: number, type: RootState['$$sheet']['type']) {
    return this.list
      .map((sheet) => {
        if (sheet[type] !== ability || sheet.hide) {
          return;
        }
        return sheet;
      })
      .filter((sheet) => sheet !== undefined)
      .sortBy((sheet) => {
        if (sheet?.title === undefined) {
          return;
        }
        return sheet.title.toLocaleLowerCase();
      });
  }

  public chunk(list: Map<number, Sheet | undefined>, chunkSize = 5) {
    return Range(0, list.count(), chunkSize).map((chunkStart) =>
      list.slice(chunkStart, chunkStart + chunkSize),
    );
  }
}
