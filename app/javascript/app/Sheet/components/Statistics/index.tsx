import * as React from 'react';
import { connect } from 'react-redux';
import { RootState } from '../../ducks/index';
import Desktop from './Desktop';
import Mobile from './Mobile';

function mapStateToProps(state: RootState) {
  return {
    $$scoreList: state.$$sheet.scoreList,
    count: state.$$sheet.sheetList.list.count(),
    color: state.$$meta.env.color,
    mobile: state.$$meta.env.mobileView(),
    type: state.$$sheet.type,
  };
}
export type StatisticsProps = ReturnType<typeof mapStateToProps>;
const Statistics: React.SFC<StatisticsProps> = (props) => (
  <div className="uk-overflow-container">
    <table className="uk-table uk-table-bordered" style={{ textAlign: 'center' }}>
    {props.mobile ? <Mobile {...props} /> : <Desktop {...props} />}
    </table>
  </div>
);

export default connect(mapStateToProps)(Statistics);
