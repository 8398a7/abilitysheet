import 'fullcalendar';
import * as $ from 'jquery';
import 'qtip2';
import * as React from 'react';
import MyClient, { ILog } from '../../../lib/MyClient';

interface IState {
  client: MyClient;
  logs: any;
}
export default class LogCalendar extends React.PureComponent<{ iidxid: string }, IState> {
  public state = {
    client: new MyClient(),
    logs: {},
  };

  public componentWillMount() {
    const today = new Date();
    const { iidxid } = this.props;
    this.state.client.getLogs(iidxid, today.getFullYear(), today.getMonth() + 1)
      .then(res => this.changeEvents(res.logs));
  }

  public changeEvents(events: ILog[]) {
    const obj: { [s: string]: ILog[] } = {};
    events.forEach(event => {
      if (obj[event.created_date] === undefined) {
        obj[event.created_date] = [];
      }
      obj[event.created_date].push(event);
    });
    Object.keys(obj).forEach(date => {
      const event = {
        title: obj[date].length + '個の更新',
        start: date,
        allDay: true,
        url: (window as any).logs_path(this.props.iidxid, date),
        description: obj[date].map(e => e.title).join('<br>'),
      };
      $('#log-calendar').fullCalendar('renderEvent', event, false);
    });
  }

  public componentDidMount() {
    (window as any).UIkit.accordion(document.querySelector('.uk-accordion'), {showfirst: false});
    $('#log-calendar').fullCalendar({
      locale: 'ja',
      eventRender: (event, element) => {
        element.qtip({
          content: { text: event.description },
        });
      },
    });
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
      dates = dom.textContent.replace(/年/g, '').replace('月', '').split(' ');
    } else { return; }
    const { iidxid } = this.props;
    this.state.client.getLogs(iidxid, parseInt(dates[1], 10), parseInt(dates[0], 10))
      .then(res => this.changeEvents(res.logs));
  }

  public render() {
    return (
      <div className="uk-accordion" data-uk-accordion={true}>
        <h3 className="uk-accordion-title center">カレンダーで見る</h3>
        <div className="uk-accordion-content">
          <div id="log-calendar" data-turbolinks="false" />
        </div>
      </div>
    );
  }
}
