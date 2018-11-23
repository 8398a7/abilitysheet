import * as React from 'react';
import { connect } from 'react-redux';
import { bindActionCreators, Dispatch } from 'redux';
import RectangleAdsense from '../../../Adsense/RectangleAdsense';
import { RootState } from '../../ducks';
import { actions } from '../../ducks/Sheet';
import LampTd from './LampTd';

function mapStateToProps(state: RootState) {
  return {
    $$sheetList: state.$$sheet.sheetList,
    $$abilities: state.$$sheet.abilities,
    $$scoreList: state.$$sheet.scoreList,
    $$env: state.$$meta.env,
    $$currentUser: state.$$meta.currentUser,
    $$user: state.$$sheet.user,
    bp: state.$$sheet.bp,
    selectDisplay: state.$$sheet.selectDisplay,
    mobile: state.$$meta.env.mobileView(),
  };
}
function mapDispatchToProps(dispatch: Dispatch) {
  const { updateScoreRequested, getModalRequested, toggleDisplaySelect } = actions;
  return bindActionCreators({ updateScoreRequested, getModalRequested, toggleDisplaySelect }, dispatch);
}
interface IProps {
  type: 'n_clear' | 'hard' | 'exh';
}
type Props = IProps & ReturnType<typeof mapStateToProps> & ReturnType<typeof mapDispatchToProps>;

class SheetList extends React.PureComponent<Props> {
  public renderSheet() {
    const { $$abilities, $$sheetList, $$scoreList, type, $$env, bp, selectDisplay } = this.props;
    const { updateLamp, handleSheetClick, owner } = this;
    const dom: JSX.Element[] = [];
    $$abilities.forEach((value, key) => {
      dom.push(
        <tr key={`ability-${type}-${key}`}>
          <th colSpan={5} style={{ textAlign: 'center', backgroundColor: '#f5deb3' }}>{value}</th>
        </tr>,
      );
      $$sheetList.chunk($$sheetList.whereAbility(key, type)).forEach(sheets => {
        const tdDom = sheets.toList().map(sheet => {
          if (sheet === undefined) { return; }
          const score = $$scoreList.findBySheetId(sheet.id);
          return (<LampTd key={`sheet-${sheet.id}`} {...{ owner: owner(), selectDisplay, updateLamp, handleSheetClick, sheet, score, $$env, bp, width: 150, height: 50 }} />);
        }).toArray();

        const ids = sheets.map(sheet => {
          if (sheet === undefined) { return; }
          return sheet.id;
        }).join('-');
        dom.push(<tr key={`sheet-${ids}`}>{tdDom}</tr>);
      });
    });
    return dom;
  }

  public renderMobile() {
    const { $$abilities, $$sheetList, $$scoreList, type, $$env, bp, selectDisplay } = this.props;
    const { updateLamp, handleSheetClick, owner } = this;
    const dom: JSX.Element[] = [];
    $$abilities.forEach((value, key) => {
      dom.push(
        <tr key={`ability-${type}-${key}`}>
          <th style={{ textAlign: 'center', backgroundColor: '#f5deb3' }}>{value}</th>
        </tr>,
      );
      $$sheetList.whereAbility(key, type).forEach(sheet => {
        if (sheet === undefined) { return; }
        const score = $$scoreList.findBySheetId(sheet.id);
        dom.push(<tr key={`sheet-${sheet.id}`} ><LampTd {...{ owner: owner(), selectDisplay, updateLamp, handleSheetClick, sheet, score, $$env, bp, width: 150, height: 50 }} /></tr>);
      });
    });
    return dom;
  }

  public updateLamp = (sheetId?: number) => (e: React.ChangeEvent<HTMLSelectElement>) => {
    const { $$currentUser, updateScoreRequested } = this.props;
    const { iidxid } = $$currentUser;
    if (iidxid === undefined || sheetId === undefined) { return; }
    const state = parseInt(e.target.value, 10);
    updateScoreRequested({ iidxid, sheetId, state });
  }

  public handleSheetClick = (sheetId?: number) => () => {
    const { $$currentUser, getModalRequested } = this.props;
    const { iidxid } = $$currentUser;
    if (iidxid === undefined || sheetId === undefined) { return; }
    getModalRequested({ iidxid, sheetId });
  }

  public handleToggleDisplaySelect = () => {
    this.props.toggleDisplaySelect();
  }

  public render() {
    return (
      <div>
        <RectangleAdsense />
        {this.props.$$currentUser.renderAds() ? <hr style={{margin: '10px 0'}} /> : null}
        {this.owner() ? <button onClick={this.handleToggleDisplaySelect} className="uk-button uk-button-primary">編集ボタン表示切替</button> : null}
        <table id="sheet-list-table" className="uk-table uk-table-bordered">
          <tbody>
            {this.props.mobile ? this.renderMobile() : this.renderSheet()}
          </tbody>
        </table>
      </div>
    );
  }

  private owner = () => {
    return this.props.$$currentUser.is(this.props.$$user);
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(SheetList);
