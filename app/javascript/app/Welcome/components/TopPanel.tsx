import * as React from 'react';
import User from '../../../lib/models/User';
import { newUserRegistrationPath } from '../../../lib/routes';

interface IProps {
  user?: User;
}
const Register: React.SFC<IProps> = ({ user }) => {
  if (user !== undefined && user.id !== -1) { return null; }
  return (
    <div className="uk-width-medium-1-3 register-link-button">
      <a href={newUserRegistrationPath()} className="uk-button-primary uk-button-large">登録</a>
    </div>
  );
};

const TopPanel: React.SFC<IProps & { mobile: boolean }> = ({ user, mobile }) => {
  const msg = mobile ? {
    title: 'SP☆12参考表',
    contents: [
      '掲示板で議論された地力表を反映',
      '地力値を用いた楽曲難易度',
      'ランプ遷移をグラフで可視化',
    ],
  } : {
    title: 'SP☆12参考表(地力表)支援サイト',
    contents: [
      '掲示板で議論された地力表を自分のランプで反映',
      '地力値を用いて楽曲の難しさを数値化',
      'ランプの遷移をグラフで可視化',
    ],
  };
  return (
    <div className="uk-block uk-contrast uk-block-large top-panel">
      <div className="uk-container">
        <h1>{msg.title}</h1>
        <div className="uk-grid uk-grid-match" data-uk-grid-margin={true}>
          <div className="uk-width-medium-1-3">{msg.contents[0]}</div>
          <div className="uk-width-medium-1-3">{msg.contents[1]}</div>
          <div className="uk-width-medium-1-3">{msg.contents[2]}</div>
          <div className="uk-width-medium-1-3" />
          <Register {...{ user }}/>
        </div>
      </div>
    </div>
  );
};

export default TopPanel;
