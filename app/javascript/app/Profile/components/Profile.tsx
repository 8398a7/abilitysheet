import * as React from 'react';
import SplineGraph from '../../../lib/components/SplineGraph';
import User from '../../../lib/models/User';
import HeatMap from './HeatMap';

interface IProps {
  user: User;
}
export default class Profile extends React.PureComponent<IProps, {}> {
  public render() {
    const { user } = this.props;
    return (
      <div>
        <HeatMap user={user} viewport={true} />
        <SplineGraph initialRender={false} iidxid={user.iidxid} />
      </div>
    );
  }
}
