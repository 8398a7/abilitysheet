import React, { SFC, useCallback } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators, Dispatch } from 'redux';
import Adsenses from '../../../Adsense/Adsenses';
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
    type: state.$$sheet.type,
  };
}
function mapDispatchToProps(dispatch: Dispatch) {
  const { updateScoreRequested, getModalRequested, toggleDisplaySelect } = actions;
  return bindActionCreators({ updateScoreRequested, getModalRequested, toggleDisplaySelect }, dispatch);
}
type Props = ReturnType<typeof mapStateToProps> & ReturnType<typeof mapDispatchToProps>;

const SheetList: SFC<Props> = (props) => {
  const {
    $$abilities, $$sheetList, $$scoreList, type, $$env, bp, selectDisplay,
    $$currentUser, $$user, mobile,
    updateScoreRequested, getModalRequested, toggleDisplaySelect,
  } = props;
  const owner = useCallback(() => {
    if ($$currentUser === undefined) { return false; }
    return $$currentUser.is(props.$$user);
  }, [$$currentUser]);

  const updateLamp = (sheetId?: number) => (e: React.ChangeEvent<HTMLSelectElement>) => {
    if ($$currentUser === undefined || sheetId === undefined) { return; }
    const { iidxid } = $$currentUser;
    const state = parseInt(e.target.value, 10);
    updateScoreRequested({ iidxid, sheetId, state });
  };

  const handleSheetClick = useCallback((sheetId?: number) => () => {
    const { iidxid } = $$user;
    if (iidxid === undefined || sheetId === undefined) { return; }
    getModalRequested({ iidxid, sheetId });
  }, []);

  const handleToggleDisplaySelect = useCallback(() => toggleDisplaySelect(), []);

  const renderSheet = () => {
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
  };

  const renderMobile = () => {
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
        dom.push(<tr key={`sheet-${sheet.id}`} ><LampTd {...{ owner: owner(), selectDisplay, updateLamp, handleSheetClick, sheet, score, $$env, bp }} /></tr>);
      });
    });
    return dom;
  };

  return (
    <>
      <Adsenses slot={1} />
      {owner() ? <button onClick={handleToggleDisplaySelect} className="uk-button uk-button-primary">編集ボタン表示切替</button> : null}
      <table id="sheet-list-table" className="uk-table uk-table-bordered">
        <tbody>
          {mobile ? renderMobile() : renderSheet()}
        </tbody>
      </table>
    </>
  );
};

export default connect(mapStateToProps, mapDispatchToProps)(SheetList);
