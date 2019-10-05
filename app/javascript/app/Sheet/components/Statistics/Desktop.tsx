import React from 'react';
import { StatisticsProps } from './index';

const Desktop: React.SFC<StatisticsProps> = props => {
  const { $$scoreList, count, type, color } = props;
  const stat = $$scoreList.statistics();
  return (
    <tbody>
      <tr>
        <td className="has-text-centered" style={{ backgroundColor: color[0] }}>
          FC
        </td>
        <td className="has-text-centered">{stat[0] || 0}</td>
        <td className="has-text-centered" style={{ backgroundColor: color[1] }}>
          EXH
        </td>
        <td className="has-text-centered">{stat[1] || 0}</td>
        <td className="has-text-centered" style={{ backgroundColor: color[2] }}>
          H
        </td>
        <td className="has-text-centered">{stat[2] || 0}</td>
        <td className="has-text-centered" style={{ backgroundColor: color[3] }}>
          C
        </td>
        <td className="has-text-centered">{stat[3] || 0}</td>
        <td className="has-text-centered" style={{ backgroundColor: color[4] }}>
          E
        </td>
        <td className="has-text-centered">{stat[4] || 0}</td>
        <td className="has-text-centered" style={{ backgroundColor: color[5] }}>
          A
        </td>
        <td className="has-text-centered">{stat[5] || 0}</td>
        <td className="has-text-centered" style={{ backgroundColor: color[6] }}>
          F
        </td>
        <td className="has-text-centered">{stat[6] || 0}</td>
        <td className="has-text-centered" style={{ backgroundColor: color[7] }}>
          N
        </td>
        <td className="has-text-centered">{$$scoreList.noPlayCount(count)}</td>
        <td
          className="has-text-centered"
          style={{ backgroundColor: '#7fffd4' }}
        >
          ({$$scoreList.completed(type)}/{count})
        </td>
      </tr>
    </tbody>
  );
};

export default Desktop;
