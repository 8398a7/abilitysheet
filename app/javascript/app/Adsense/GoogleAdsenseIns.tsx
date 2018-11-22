import * as React from 'react';

interface IProps {
  client: string;
  slot: string;
  className: string;
  style: { [s: string]: string };
  format?: string;
}
const GoogleAdsenseIns: React.SFC<IProps> = (props) => {
  const style = { ...props.style };
  style.backgroundColor = 'white';
  return (
    <ins
      className={'adsbygoogle ' + props.className}
      style={style}
      data-full-width-responsive="true"
      data-ad-client={props.client}
      data-ad-slot={props.slot}
      data-ad-format={props.format}
    />
  );
};

export default GoogleAdsenseIns;
