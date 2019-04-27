import React, { SFC, useMemo } from 'react';
import { Props } from '.';

interface IProps {
  versions: Props['versions'];
  reverse: boolean;
  handleToggleVersion: (e: React.ChangeEvent<HTMLInputElement>) => void;
  handleChangeReverse: () => void;
}
const Presentation: SFC<IProps> = (props) => {
  const {
    versions, reverse,
    handleToggleVersion, handleChangeReverse,
  } = props;
  const domList = useMemo(() => versions.reduce<JSX.Element[]>((acc, cur) => {
    if (cur[1] === 0) {
      return [
        ...acc,
        (<label key={`version-checkbox-${cur}`}>
          <input type="checkbox" value={cur[1]} name="all-version-check" defaultChecked={true} onChange={handleToggleVersion} />
          {cur[0]}
        </label>),
      ];
    }
    return [
      ...acc,
      (<label key={`version-checkbox-${cur}`}>
        <input type="checkbox" value={cur[1]} name="version-check" defaultChecked={true} onChange={handleToggleVersion} />
        {cur[0]}
      </label>),
    ];
  }, []), [versions]);
  const constantDom = useMemo(() => (
    [
      (<label key="version-checkbox-reverse">
        <input type="checkbox" value="0" name="reverse" checked={reverse} onChange={handleChangeReverse} />
        逆順表示
      </label>),
    ]
  ), [reverse]);

  return (
    <div className="version-checkbox">
      {[...domList, ...constantDom]}
    </div>
  );
};

export default Presentation;
