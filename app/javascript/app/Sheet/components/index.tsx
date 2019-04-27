import React from 'react';
import { connect } from 'react-redux';
import { bindActionCreators, Dispatch } from 'redux';
import HelmetWrapper from '../../../lib/components/HelmetWrapper';
import { actions as metaActions } from '../../../lib/ducks/Meta';
import TwitterSharedButton from '../../TwitterSharedButton';
import { RootState } from '../ducks';
import { actions } from '../ducks/Sheet';
import BpForm from './BpForm';
import CheckBox from './CheckBox/index';
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
    mobile: state.$$meta.env.mobileView(),
    implicitMobile: state.$$meta.env.implicitMobile,
    type: state.$$sheet.type,
    recent: state.$$sheet.recent,
  };
}
function mapDispatchToProps(dispatch: Dispatch) {
  const { getUser, updateBp } = actions;
  const { toggleViewport } = metaActions;
  return bindActionCreators({ getUser, updateBp, toggleViewport }, dispatch);
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
class Sheet extends React.PureComponent<Props> {
  public componentWillMount() {
    const { type } = this.props;
    const { iidxid } = this.props.user;
    this.props.getUser({ iidxid, type });
  }

  public handleChangeBp = (e: React.ChangeEvent<HTMLInputElement>) => {
    this.props.updateBp(e.target.value);
  }

  public handleToggleView = () => {
    this.props.toggleViewport();
  }

  public renderToggleView() {
    const { mobile } = this.props;
    return (
      <button className="uk-button uk-button-success" onClick={this.handleToggleView}>
        <i className="fa fa-refresh" />
        {mobile === true ? 'PCサイト版' : 'モバイル版'}
      </button>
    );
  }

  public render() {
    const { user, type, recent, $$scoreList, count, bp, mobile, implicitMobile } = this.props;
    return (
      <div className="react">
        <HelmetWrapper {...{ mobile }} />
        <Modal />
        <div className="center">
          <Title {...{ type, $$scoreList, count }} />
          <ProfileLink {...{ user }} />
          <OtherLinks {...{ type, iidxid: user.iidxid }} />
          <RecentUpdate {...{ recent }} />
          {implicitMobile ? this.renderToggleView() : null}
          {$$scoreList.fetched ? <TwitterSharedButton text={`DJ.${user.djname} ☆12${mapping[type].name}(${mapping[type].remain}${$$scoreList.remainCount(type, count)})`} /> : null}
          <hr />
          <CheckBox  />
          <Statistics />
          <h3 />
          <BpForm {...{ bp, handleChangeBp: this.handleChangeBp }} />
          <br />
          <SheetList />
        </div>
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Sheet);
