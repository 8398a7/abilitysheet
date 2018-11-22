import * as React from 'react';
import User from '../../../lib/models/User';

interface IProps {
  user: User;
}
const ProfileLink: React.SFC<IProps> = (props) => {
  const { user } = props;
  return (
    <h3>
      <a href={(window as any).user_path(user.iidxid)}>{`DJ.${user.djname}(${user.iidxid})`}</a>
    </h3>
  );
};

export default ProfileLink;
