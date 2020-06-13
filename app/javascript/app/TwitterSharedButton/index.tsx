import React from 'react';
import { Mention, Share } from 'react-twitter-widgets';

export interface ITwitterSharedButton {
  text: string;
}
const TwitterSharedButton: React.SFC<ITwitterSharedButton> = (props) => {
  const options = {
    lang: 'ja',
    text: props.text,
    size: 'large',
    related: 'IIDX_12,IidxScoreTable',
    hashtags: 'iidx_app',
  };
  return (
    <span>
      <div style={{ marginTop: '5px' }} />
      <Mention
        {...{
          username: 'IIDX_12',
          options: {
            lang: 'ja',
            text: '不具合報告や機能要望等をお書きください',
          },
        }}
      />
      <div style={{ marginTop: '5px' }} />
      <Share {...{ url: location.href, options }} />
    </span>
  );
};

export default TwitterSharedButton;
