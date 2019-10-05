import React from 'react';
import { RootState } from '../ducks';
import ScoreList from '../models/ScoreList';

const mapping = {
  n_clear: {
    name: 'ノマゲ参考表',
    remain: '未クリア',
  },
  hard: {
    name: 'ハード参考表',
    remain: '未難',
  },
  exh: {
    name: 'エクハ参考表',
    remain: '未エクハ',
  },
};
interface IProps {
  type: RootState['$$sheet']['type'];
  $$scoreList: ScoreList;
  count: number;
}
const Title: React.SFC<IProps> = props => {
  const { type, $$scoreList, count } = props;
  return (
    <h3 className="subtitle is-3">
      <i className="fa fa-table" />
      {mapping[type].name}({mapping[type].remain}
      {$$scoreList.remainCount(type, count)})
    </h3>
  );
};

export default Title;
