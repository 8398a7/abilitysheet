import * as React from 'react';
import { StatisticsProps } from './index';

const Mobile: React.SFC<StatisticsProps> = (props) => {
  const { $$scoreList, count, type, color } = props;
  const stat = $$scoreList.statistics();
  return (
    <tbody>
      <tr>
        <td style={{ backgroundColor: color[0] }}>FC</td>
        <td>{stat[0] || 0}</td>
        <td style={{ backgroundColor: color[1] }}>EXH</td>
        <td>{stat[1] || 0}</td>
        <td style={{ backgroundColor: color[2] }}>H</td>
        <td>{stat[2] || 0}</td>
      </tr>
      <tr>
        <td style={{ backgroundColor: color[3] }}>C</td>
        <td>{stat[3] || 0}</td>
        <td style={{ backgroundColor: color[4] }}>E</td>
        <td>{stat[4] || 0}</td>
        <td style={{ backgroundColor: color[5] }}>A</td>
        <td>{stat[5] || 0}</td>
      </tr>
      <tr>
        <td style={{ backgroundColor: color[6] }}>F</td>
        <td>{stat[6] || 0}</td>
        <td style={{ backgroundColor: color[7] }}>N</td>
        <td>{$$scoreList.noPlayCount(count)}</td>
        <td style={{ backgroundColor: '#7fffd4'}}>
          ({$$scoreList.completed(type)}/{count})
        </td>
      </tr>
    </tbody>
  );
};

export default Mobile;
