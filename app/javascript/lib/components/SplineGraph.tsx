import Highcharts from 'highcharts';
import React from 'react';
import MyClient from '../MyClient';

interface IProps {
  initialRender: boolean;
  iidxid?: string;
}
export default class SplineGraph extends React.Component<IProps, any> {
  constructor(props: IProps) {
    super(props);

    const today = new Date();
    this.state = {
      year: today.getFullYear(),
      month: today.getMonth() + 1,
      options: {
        chart: { renderTo: 'spline-graph', defaultSeriesType: 'spline' },
        title: { text: '統計情報' },
        xAxis: { categories: ['2015-12', '2016-01', '2016-02'] },
        yAxis: [
          {
            allowDecimals: false,
            title: { text: '更新数' },
            max: 40,
            min: 0,
            opposite: true,
          },
          {
            allowDecimals: false,
            min: 0,
            title: { text: '未達成数' },
          },
        ],
        tooltip: { shared: true, crosshairs: true },
        series: [
          {
            yAxis: 0,
            type: 'column',
            name: 'FC',
            data: [15, 10, 20],
            color: '#ff8c00',
          },
          {
            yAxis: 0,
            type: 'column',
            name: 'EXH',
            data: [30, 20, 22],
            color: '#ffd900',
          },
          {
            yAxis: 0,
            type: 'column',
            name: 'HARD',
            data: [40, 10, 33],
            color: '#ff6347',
          },
          {
            yAxis: 0,
            type: 'column',
            name: 'CLEAR',
            data: [5, 2, 1],
            color: '#afeeee',
          },
          {
            yAxis: 0,
            type: 'column',
            name: 'EASY',
            data: [3, 0, 0],
            color: '#98fb98',
          },
          {
            yAxis: 1,
            type: 'spline',
            name: '未FC',
            data: [70, 60, 40],
            color: '#ff8c00',
          },
          {
            yAxis: 1,
            type: 'spline',
            name: '未EXH',
            data: [60, 40, 18],
            color: '#ffd900',
          },
          {
            yAxis: 1,
            type: 'spline',
            name: '未難',
            data: [80, 70, 47],
            color: '#ff6347',
          },
          {
            yAxis: 1,
            type: 'spline',
            name: '未クリア',
            data: [20, 12, 11],
            color: '#afeeee',
          },
          {
            type: 'pie',
            name: 'クリア割合',
            data: [
              { name: 'FC', y: 10, color: '#ff8c00' },
              { name: 'EXH', y: 10, color: '#ffd900' },
              { name: 'HARD', y: 10, color: '#ff6347' },
              { name: 'CLEAR', y: 10, color: '#afeeee' },
              { name: 'EASY', y: 10, color: '#98fb98' },
              { name: 'ASSIST', y: 10, color: '#9595ff' },
              { name: 'FAILED', y: 10, color: '#c0c0c0' },
              { name: 'NOPLAY', y: 10, color: '#ffffff' },
            ],
            center: [300, 60],
            size: 100,
            showInLegend: false,
            dataLabels: { enabled: false },
          },
        ],
      },
    };
  }

  public updatePie(options: any, graph: any) {
    options.series[9].data.forEach(
      (_: any, index: number) =>
        (options.series[9].data[index].y = graph.pie[index]),
    );
    options.series[9].center = [200, 40];
    return options;
  }

  public updateColumn(options: any, graph: any) {
    [0, 1, 2, 3, 4].forEach(
      index => (options.series[index].data = graph.column[index]),
    );
    options.yAxis[0].max = graph.column_max;
    return options;
  }

  public updateSpline(options: any, graph: any) {
    [5, 6, 7, 8].forEach(
      index => (options.series[index].data = graph.spline[index - 5]),
    );
    options.yAxis[1].max = graph.spline_max;
    return options;
  }

  public handleChange = (graph: any) => {
    let options = { ...this.state.options };
    options.xAxis.categories = graph.categories;
    options = this.updatePie(options, graph);
    options = this.updateColumn(options, graph);
    options = this.updateSpline(options, graph);
    this.setState({ options }, this.renderChart);
  };

  public UNSAFE_componentWillMount() {
    if (this.props.initialRender) {
      return null;
    }
    this.getGraph();
  }

  public getGraph() {
    const { iidxid } = this.props;
    if (iidxid === undefined) {
      return;
    }
    const client = new MyClient();
    const { year, month } = this.state;
    client
      .getGraph(iidxid, year, month)
      .then(graph => this.handleChange(graph));
  }

  public componentDidMount() {
    if (!this.props.initialRender) {
      return null;
    }
    this.renderChart();
  }

  public renderChart() {
    Highcharts.chart(this.state.options);
  }

  public handleClickPrev = () => {
    let [year, month] = [this.state.year, this.state.month];
    if (this.state.month === 1) {
      year -= 1;
      month = 12;
    } else {
      month -= 1;
    }
    this.setState({ year, month }, this.getGraph);
  };

  public handleClickNext = () => {
    let [year, month] = [this.state.year, this.state.month];
    if (this.state.month === 12) {
      year += 1;
      month = 1;
    } else {
      month += 1;
    }
    this.setState({ year, month }, this.getGraph);
  };

  public render() {
    return (
      <div>
        <div id="spline-graph" />
        {this.props.initialRender ? null : (
          <button className="button is-danger" onClick={this.handleClickPrev}>
            prev
          </button>
        )}
        {this.props.initialRender ? null : (
          <button className="button is-info" onClick={this.handleClickNext}>
            next
          </button>
        )}
      </div>
    );
  }
}
