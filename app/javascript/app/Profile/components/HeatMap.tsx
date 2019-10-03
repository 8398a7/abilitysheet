import CalHeatMap from 'cal-heatmap';
import React, { FC, SFC, useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { RootState } from '../../../lib/ducks';
import User from '../../../lib/models/User';
import { apiV1LogCalHeatmapPath, logsPath } from '../../../lib/routes';

const Detail: SFC<{ user: User; date: string; items: number }> = ({
  user,
  date,
  items,
}) => {
  if (items === -1) {
    return null;
  }
  const targetDate = new Date(date);
  const text = `${targetDate.getFullYear()}-${(
    '00' +
    (targetDate.getMonth() + 1)
  ).substr(-2)}-${('00' + targetDate.getDate()).substr(-2)}`;

  return (
    <div className="center">
      <i className="fa fa-refresh" />
      <a href={logsPath(user.iidxid, text)}>{text}</a>の更新数は{items}個です
    </div>
  );
};

const HeatMap: FC<{ user: User }> = ({ user }) => {
  const mobile = useSelector((state: RootState) =>
    state.$$meta.env.mobileView(),
  );
  const [date, setDate] = useState('');
  const [items, setItems] = useState(-1);

  useEffect(() => {
    if (user.iidxid === undefined) {
      return;
    }
    // @ts-ignore
    const cal = new CalHeatMap();
    const startDate = new Date();
    const range = mobile ? 3 : 12;
    startDate.setMonth(startDate.getMonth() - (range - 1));
    cal.init({
      domain: 'month',
      subDomain: 'day',
      data: `${apiV1LogCalHeatmapPath(
        user.iidxid,
      )}?start={{d:start}}&stop={{d:end}}`,
      start: startDate,
      range,
      tooltip: true,
      cellSize: 9,
      domainLabelFormat: '%Y-%m',
      afterLoadData(timestamps: { [s: string]: number }) {
        const offset = (540 + new Date().getTimezoneOffset()) * 60;
        const results: { [key: number]: number } = {};
        Object.keys(timestamps).forEach(timestamp => {
          const commitCount = timestamps[timestamp];
          results[parseInt(timestamp, 10) + offset] = commitCount;
        });
        return results;
      },
      onClick: (d: Date, nb: number) => {
        setDate(d.toLocaleDateString());
        setItems(nb);
      },
    });
  }, []);

  return (
    <article className="message is-info">
      <div className="message-header">更新履歴</div>
      <div className="message-body">
        <div id="cal-heatmap" />
        <Detail {...{ user, date, items }} />
      </div>
    </article>
  );
};

export default HeatMap;
