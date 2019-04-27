import { EventApi, View } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import FullCalendar from '@fullcalendar/react';
import React, { PureComponent } from 'react';
import Tooltip from 'tooltip.js';
import MyClient, { ILog } from '../../../lib/MyClient';
import { logsPath } from '../../../lib/routes';

interface IState {
  client: MyClient;
  events: Array<{
    title: string;
    start: string;
    allDay: boolean;
    url: string;
    description: string;
  }>;
}
export default class LogCalendar extends PureComponent<{ iidxid: string }, IState> {
  public state = {
    client: new MyClient(),
    events: [],
  };

  public componentWillMount() {
    const today = new Date();
    const { iidxid } = this.props;
    this.state.client.getLogs(iidxid, today.getFullYear(), today.getMonth() + 1)
      .then(res => this.changeEvents(res.logs));
  }

  public changeEvents(logs: ILog[]) {
    const obj: { [s: string]: ILog[] } = {};
    logs.forEach(log => {
      if (obj[log.created_date] === undefined) {
        obj[log.created_date] = [];
      }
      obj[log.created_date].push(log);
    });
    const events = Object.keys(obj).map(date => {
      return {
        title: obj[date].length + '個の更新',
        start: date,
        allDay: true,
        url: logsPath(this.props.iidxid, date),
        description: obj[date].map(e => e.title).join('<br>'),
      };
    });
    this.setState({ events });
  }

  public handleEventRender = (info: { event: EventApi, el: HTMLElement, view: View }) => {
    // @ts-ignore
    const tooltip = new Tooltip(info.el, {
      title: info.event.extendedProps.description,
      html: true,
      placement: 'bottom',
    });
  }

  public componentDidMount() {
    (window as any).UIkit.accordion(document.querySelector('.uk-accordion'), {showfirst: false});
    const prev = document.querySelector<HTMLSpanElement>('.fc-prev-button');
    if (prev) { prev.onclick = this.handleClickPrevNext; }
    const next = document.querySelector<HTMLSpanElement>('.fc-next-button');
    if (next) { next.onclick = this.handleClickPrevNext; }
    const today = document.querySelector<HTMLSpanElement>('.fc-today-button');
    if (today) { today.onclick = this.handleClickPrevNext; }
  }

  public handleClickPrevNext = () => {
    const dom = document.querySelector('.fc-left');
    let dates: string[];
    if (dom && dom.textContent) {
      dates = dom.textContent.replace(/年/g, ' ').replace('月', ' ').split(' ');
    } else { return; }
    const { iidxid } = this.props;
    this.state.client.getLogs(iidxid, parseInt(dates[0], 10), parseInt(dates[1], 10))
      .then(res => this.changeEvents(res.logs));
  }

  public render() {
    return (
      <div className="uk-accordion" data-uk-accordion={true}>
        <h3 className="uk-accordion-title center">カレンダーで見る</h3>
        <div className="uk-accordion-content">
          <FullCalendar
            locale="ja"
            defaultView="dayGridMonth"
            plugins={[dayGridPlugin]}
            events={this.state.events}
            eventRender={this.handleEventRender}
          />
        </div>
      </div>
    );
  }
}
