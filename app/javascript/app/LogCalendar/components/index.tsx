import { EventApi, View } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import FullCalendar from '@fullcalendar/react';
import React, { FC, useCallback, useState } from 'react';
import Tooltip from 'tooltip.js';

import MyClient, { ILog } from '../../../lib/MyClient';
import { logsPath } from '../../../lib/routes';

interface IEvent {
  title: string;
  start: string;
  allDay: boolean;
  url: string;
  description: string;
}

let viewDate: string[] = [];
const LogCalendar: FC<{ iidxid: string }> = ({ iidxid }) => {
  const [client] = useState(new MyClient());
  const [events, setEvents] = useState<IEvent[]>([]);

  const changeEvents = useCallback(
    (logs: ILog[]) => {
      const obj: { [s: string]: ILog[] } = {};
      logs.forEach((log) => {
        if (obj[log.created_date] === undefined) {
          obj[log.created_date] = [];
        }
        obj[log.created_date].push(log);
      });
      const newEvents = Object.keys(obj).map((date) => {
        return {
          title: obj[date].length + '個の更新',
          start: date,
          allDay: true,
          url: logsPath(iidxid, date),
          description: obj[date].map((e) => e.title).join('<br>'),
        };
      });
      setEvents(newEvents);
    },
    [events],
  );

  const handleClickPrevNext = useCallback(
    (args: { view: View; el: HTMLElement }) => {
      const dates = args.view.title
        .replace(/年/g, ' ')
        .replace('月', ' ')
        .split(' ');
      if (dates[0] === viewDate[0] && dates[1] === viewDate[1]) {
        return;
      }
      viewDate = dates;
      client
        .getLogs(iidxid, parseInt(dates[0], 10), parseInt(dates[1], 10))
        .then((res) => changeEvents(res.logs));
    },
    [],
  );

  const handleEventRender = useCallback(
    (info: { event: EventApi; el: HTMLElement; view: View }) => {
      // @ts-ignore
      const tooltip = new Tooltip(info.el, {
        title: info.event.extendedProps.description,
        html: true,
        placement: 'bottom',
      });
    },
    [],
  );

  return (
    <FullCalendar
      locale="ja"
      defaultView="dayGridMonth"
      plugins={[dayGridPlugin]}
      events={events}
      eventRender={handleEventRender}
      datesRender={handleClickPrevNext}
    />
  );
};

export default LogCalendar;
