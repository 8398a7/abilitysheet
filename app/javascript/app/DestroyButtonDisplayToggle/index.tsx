import React, { FC, useCallback, useState } from 'react';

const DestroyButtonDisplayToggle: FC = () => {
  const [display, setDisplay] = useState(false);

  const handleClick = useCallback((type: boolean) => () => {
    document.querySelectorAll<HTMLButtonElement>('.destroy-button').forEach(elem => elem.style.display = type ? 'none' : '');
    setDisplay(type);
  }, [display]);
  const hide = useCallback(handleClick(true), [handleClick]);
  const show = useCallback(handleClick(false), [handleClick]);

  return (
    <>
      <button onClick={hide} className={`button is-small is-info ${!display ? ' uk-active' : '' }`}>非表示</button>
      <button onClick={show} className={`button is-small is-danger ${display ? ' uk-active' : '' }`}>表示</button>
    </>
  );
};

export default DestroyButtonDisplayToggle;
