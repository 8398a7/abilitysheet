import * as React from 'react';
import User from '../../../lib/models/User';
import { userPath } from '../../../lib/routes';

interface IProps {
  user: User;
}
const ProfileLink: React.SFC<IProps> = (props) => {
  const { user } = props;
  if (user.iidxid === undefined) { return null; }
  return (
    <h3>
      <a href={userPath(user.iidxid)}>{`DJ.${user.djname}(${user.iidxid})`}</a>
    </h3>
  );
};

export default ProfileLink;
