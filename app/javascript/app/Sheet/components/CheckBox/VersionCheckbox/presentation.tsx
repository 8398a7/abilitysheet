import React, { SFC, useMemo } from 'react';

interface IProps {
  versions: Array<[string, number]>;
  reverse: boolean;
  handleToggleVersion: (e: React.ChangeEvent<HTMLInputElement>) => void;
  handleChangeReverse: () => void;
}
const Presentation: SFC<IProps> = (props) => {
  const { versions, reverse, handleToggleVersion, handleChangeReverse } = props;
  const domList = useMemo(
    () =>
      versions.reduce<JSX.Element[]>((acc, cur) => {
        if (cur[1] === 0) {
          return [
            ...acc,
            <span key={`version-checkbox-${cur}`}>
              <input
                type="checkbox"
                value={cur[1]}
                name="all-version-check"
                id="all-version-check"
                className="is-checkradio is-info is-circle"
                defaultChecked={true}
                onChange={handleToggleVersion}
              />
              <label htmlFor="all-version-check">{cur[0]}</label>
            </span>,
          ];
        }
        return [
          ...acc,
          <span key={`version-checkbox-${cur}`}>
            <input
              type="checkbox"
              value={cur[1]}
              name="version-check"
              id={`version-check-${cur[1]}`}
              className="is-checkradio is-info is-circle"
              defaultChecked={true}
              onChange={handleToggleVersion}
            />
            <label htmlFor={`version-check-${cur[1]}`}>{cur[0]}</label>
          </span>,
        ];
      }, []),
    [versions],
  );
  const constantDom = useMemo(
    () => [
      <span key="version-checkbox-reverse">
        <input
          type="checkbox"
          value="0"
          name="reverse"
          id="reverse-checkbox"
          className="is-checkradio is-info is-circle"
          checked={reverse}
          onChange={handleChangeReverse}
        />
        <label htmlFor="reverse-checkbox">逆順表示</label>
      </span>,
    ],
    [reverse],
  );

  return <div className="version-checkbox">{[...domList, ...constantDom]}</div>;
};

export default Presentation;
