import React, { SFC, useCallback } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import Adsenses from '../../../Adsense/Adsenses';
import { RootState } from '../../ducks';
import { actions } from '../../ducks/Sheet';
import LampTd from './LampTd';

const SheetList: SFC = (props) => {
  const dispatch = useDispatch();
  const $$sheetList = useSelector(
    (state: RootState) => state.$$sheet.sheetList,
  );
  const $$abilities = useSelector(
    (state: RootState) => state.$$sheet.abilities,
  );
  const $$scoreList = useSelector(
    (state: RootState) => state.$$sheet.scoreList,
  );
  const $$currentUser = useSelector(
    (state: RootState) => state.$$meta.currentUser,
  );
  const $$user = useSelector((state: RootState) => state.$$sheet.user);
  const mobile = useSelector((state: RootState) =>
    state.$$meta.env.mobileView(),
  );
  const type = useSelector((state: RootState) => state.$$sheet.type);

  const owner = useCallback(() => {
    if ($$currentUser === undefined) {
      return false;
    }
    return $$currentUser.is($$user);
  }, [$$currentUser]);

  const updateLamp = useCallback(
    (sheetId?: number) => (e: React.ChangeEvent<HTMLSelectElement>) => {
      if ($$currentUser === undefined || sheetId === undefined) {
        return;
      }
      const { iidxid } = $$currentUser;
      const state = parseInt(e.target.value, 10);
      dispatch(actions.updateScoreRequested({ iidxid, sheetId, state }));
    },
    [$$currentUser],
  );

  const handleSheetClick = useCallback(
    (sheetId?: number) => (e: React.MouseEvent) => {
      e.preventDefault();
      const { iidxid } = $$user;
      if (iidxid === undefined || sheetId === undefined) {
        return;
      }
      dispatch(actions.getModalRequested({ iidxid, sheetId }));
    },
    [],
  );

  const handleToggleDisplaySelect = useCallback(
    () => dispatch(actions.toggleDisplaySelect()),
    [],
  );

  const renderSheet = () => {
    const dom: JSX.Element[] = [];
    $$abilities.forEach((value, key) => {
      dom.push(
        <tr key={`ability-${type}-${key}`}>
          <th
            colSpan={5}
            style={{ textAlign: 'center', backgroundColor: '#f5deb3' }}
          >
            {value}
          </th>
        </tr>,
      );
      $$sheetList
        .chunk($$sheetList.whereAbility(key, type))
        .forEach((sheets) => {
          const tdDom = sheets
            .toList()
            .map((sheet) => {
              if (sheet === undefined) {
                return;
              }
              const score = $$scoreList.findBySheetId(sheet.id);
              return (
                <LampTd
                  key={`sheet-${sheet.id}`}
                  {...{
                    owner: owner(),
                    updateLamp,
                    handleSheetClick,
                    sheet,
                    score,
                    width: 150,
                    height: 50,
                  }}
                />
              );
            })
            .toArray();

          const ids = sheets.map((sheet) => sheet?.id).join('-');
          dom.push(<tr key={`sheet-${ids}`}>{tdDom}</tr>);
        });
    });
    return dom;
  };

  const renderMobile = () => {
    const dom: JSX.Element[] = [];
    $$abilities.forEach((value, key) => {
      dom.push(
        <tr key={`ability-${type}-${key}`} className="levelttl">
          <th style={{ textAlign: 'center', backgroundColor: '#f5deb3'}}>
            {value}
          </th>
        </tr>,
      );
      $$sheetList.whereAbility(key, type).forEach((sheet) => {
        if (sheet === undefined) {
          return;
        }
        const score = $$scoreList.findBySheetId(sheet.id);
        dom.push(
          <tr key={`sheet-${sheet.id}`} className="lamp">
            <LampTd
              {...{
                owner: owner(),
                updateLamp,
                handleSheetClick,
                sheet,
                score,
              }}
            />
          </tr>,
        );
      });
    });
    return dom;
  };

  return (
    <>
      <Adsenses slot={1} />
      {owner() ? (
        <button
          onClick={handleToggleDisplaySelect}
          className="button is-primary"
          style={{ marginBottom: '10px' }}
        >
          編集ボタン表示切替
        </button>
      ) : null}
      <table id="sheet-list-table" className="table is-fullwidth">
        <tbody>{mobile ? renderMobile() : renderSheet()}</tbody>
      </table>
    </>
  );
};

export default SheetList;
