import React, { SFC } from 'react';
import SplineGraph from '../../../lib/components/SplineGraph';
import User from '../../../lib/models/User';
import HeatMap from './HeatMap';

const Profile: SFC<{ user: User }> = ({ user }) => (
  <>
    <HeatMap user={user} />
    <SplineGraph initialRender={false} iidxid={user.iidxid} />
  </>
);

export default Profile;
