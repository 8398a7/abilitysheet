import React from 'react';
import User from '../../../lib/models/User';
import { newUserRegistrationPath } from '../../../lib/routes';

interface IProps {
  user?: User;
}
const Register: React.SFC<IProps> = ({ user }) => {
  if (user !== undefined && user.id !== -1) {
    return null;
  }
  return (
    <div className="has-text-centered" style={{ marginTop: '50px' }}>
      <a href={newUserRegistrationPath()} className="button is-link is-large">
        登録
      </a>
    </div>
  );
};

const TopPanel: React.SFC<IProps & { mobile: boolean }> = ({
  user,
  mobile,
}) => {
  const msg = mobile
    ? {
        title: 'SP☆12参考表',
        contents: [
          '掲示板で議論された地力表を反映',
          '地力値を用いた楽曲難易度',
          'ランプ遷移をグラフで可視化',
        ],
      }
    : {
        title: 'SP☆12参考表(地力表)支援サイト',
        contents: [
          '掲示板で議論された地力表を自分のランプで反映',
          '地力値を用いて楽曲の難しさを数値化',
          'ランプの遷移をグラフで可視化',
        ],
      };
  return (
    <section className="hero is-dark is-bold">
      <div className="hero-body">
        <div className="container">
          <h1 className="title">{msg.title}</h1>
          <div className="columns">
            <div className="column">{msg.contents[0]}</div>
            <div className="column">{msg.contents[1]}</div>
            <div className="column">{msg.contents[2]}</div>
          </div>
        </div>
        <Register {...{ user }} />
      </div>
    </section>
  );
};

export default TopPanel;
