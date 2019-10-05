import React from 'react';
import User from '../../../lib/models/User';
import { userPath } from '../../../lib/routes';

interface IProps {
  user: User;
}
const ProfileLink: React.SFC<IProps> = props => {
  const { user } = props;
  return (
    <h4 className="subtitle is-4">
      <a href={userPath(user.iidxid)}>{`DJ.${user.djname}(${user.iidxid})`}</a>
    </h4>
  );
};

export default ProfileLink;
