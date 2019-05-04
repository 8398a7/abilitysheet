import React, { SFC, useCallback, useEffect } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators, Dispatch } from 'redux';
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

function mapStateToProps(state: RootState) {
  return {
    currentUser: state.$$meta.currentUser,
    user: state.$$sheet.user,
    count: state.$$sheet.sheetList.list.count(),
    $$scoreList: state.$$sheet.scoreList,
    bp: state.$$sheet.bp,
    filterName: state.$$sheet.filterName,
    mobile: state.$$meta.env.mobileView(),
    implicitMobile: state.$$meta.env.implicitMobile,
    type: state.$$sheet.type,
    recent: state.$$sheet.recent,
  };
}
function mapDispatchToProps(dispatch: Dispatch) {
  const { getUser, updateBp, updateFilterName } = actions;
  const { toggleViewport } = metaActions;
  return bindActionCreators({ getUser, updateBp, updateFilterName, toggleViewport }, dispatch);
}
type Props = ReturnType<typeof mapStateToProps> & ReturnType<typeof mapDispatchToProps>;
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

const ToggleView: SFC<{ implicitMobile: boolean, mobile: boolean, handleToggleView: () => void }> = ({ implicitMobile, mobile, handleToggleView }) => {
  if (!implicitMobile) { return null; }
  return (
    <button className="uk-button uk-button-success" onClick={handleToggleView}>
      <i className="fa fa-refresh" />
      {mobile === true ? 'PCサイト版' : 'モバイル版'}
    </button>
  );
};

const Sheet: SFC<Props> = (props) => {
  useEffect(() => {
    const { iidxid } = props.user;
    props.getUser({ iidxid, type });
  }, []);

  const handleChangeBp = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    props.updateBp(e.target.value);
  }, []);
  const handleChangeName = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    props.updateFilterName(e.target.value);
  }, []);
  const handleToggleView = useCallback(() => props.toggleViewport(), []);

  const { user, type, recent, $$scoreList, count, bp, filterName, mobile, implicitMobile } = props;

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
        {$$scoreList.fetched ? <TwitterSharedButton text={`DJ.${user.djname} ☆12${mapping[type].name}(${mapping[type].remain}${$$scoreList.remainCount(type, count)})`} /> : null}
        <hr />
        <CheckBox  />
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

export default connect(mapStateToProps, mapDispatchToProps)(Sheet);
