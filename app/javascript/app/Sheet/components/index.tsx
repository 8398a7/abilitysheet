import React, { SFC, useCallback, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import HelmetWrapper from '../../../lib/components/HelmetWrapper';
import { actions as metaActions } from '../../../lib/ducks/Meta';
import TwitterSharedButton from '../../TwitterSharedButton';
import { RootState } from '../ducks';
import { actions } from '../ducks/Sheet';
import BpForm from './BpForm';
import CheckBox from './CheckBox/index';
import FilterNameForm from './FilterNameForm';
import Modal from './Modal';
import OtherLinks from './OtherLinks';
import ProfileLink from './ProfileLink';
import RecentUpdate from './RecentUpdate';
import SheetList from './SheetList';
import Statistics from './Statistics';
import Title from './Title';

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

const ToggleView: SFC<{
  implicitMobile: boolean;
  mobile: boolean;
  handleToggleView: () => void;
}> = ({ implicitMobile, mobile, handleToggleView }) => {
  if (!implicitMobile) {
    return null;
  }
  return (
    <button className="uk-button uk-button-success" onClick={handleToggleView}>
      <i className="fa fa-refresh" />
      {mobile === true ? 'PCサイト版' : 'モバイル版'}
    </button>
  );
};

const Sheet: SFC = () => {
  const dispatch = useDispatch();
  const user = useSelector((state: RootState) => state.$$sheet.user);
  const count = useSelector((state: RootState) =>
    state.$$sheet.sheetList.list.count(),
  );
  const $$scoreList = useSelector(
    (state: RootState) => state.$$sheet.scoreList,
  );
  const bp = useSelector((state: RootState) => state.$$sheet.bp);
  const filterName = useSelector(
    (state: RootState) => state.$$sheet.filterName,
  );
  const mobile = useSelector((state: RootState) =>
    state.$$meta.env.mobileView(),
  );
  const implicitMobile = useSelector(
    (state: RootState) => state.$$meta.env.implicitMobile,
  );
  const type = useSelector((state: RootState) => state.$$sheet.type);
  const recent = useSelector((state: RootState) => state.$$sheet.recent);
  useEffect(() => {
    const { iidxid } = user;
    dispatch(actions.getUser({ iidxid, type }));
  }, []);

  const handleChangeBp = useCallback(
    (e: React.ChangeEvent<HTMLInputElement>) => {
      dispatch(actions.updateBp(e.target.value));
    },
    [],
  );
  const handleChangeName = useCallback(
    (e: React.ChangeEvent<HTMLInputElement>) => {
      dispatch(actions.updateFilterName(e.target.value));
    },
    [],
  );
  const handleToggleView = useCallback(
    () => dispatch(metaActions.toggleViewport()),
    [],
  );

  return (
    <div className="react">
      <HelmetWrapper {...{ mobile }} />
      <Modal />
      <div className="center">
        <Title {...{ type, $$scoreList, count }} />
        <ProfileLink {...{ user }} />
        <OtherLinks {...{ type, iidxid: user.iidxid }} />
        <RecentUpdate {...{ recent }} />
        <ToggleView {...{ implicitMobile, mobile, handleToggleView }} />
        {$$scoreList.fetched ? (
          <TwitterSharedButton
            text={`DJ.${user.djname} ☆12${mapping[type].name}(${
              mapping[type].remain
            }${$$scoreList.remainCount(type, count)})`}
          />
        ) : null}
        <hr />
        <CheckBox />
        <Statistics />
        <h3 />
        <BpForm {...{ bp, handleChangeBp }} />
        <FilterNameForm {...{ name: filterName, handleChangeName }} />
        <br />
        <SheetList />
      </div>
    </div>
  );
};

export default Sheet;
