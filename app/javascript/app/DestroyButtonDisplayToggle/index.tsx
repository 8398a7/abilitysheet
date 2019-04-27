import React, { FC, useCallback, useState } from 'react';

const DestroyButtonDisplayToggle: FC<{}> = () => {
  const [display, setDisplay] = useState(false);

  const handleClick = useCallback(
    (type: boolean) => () => {
      document.querySelectorAll<HTMLButtonElement>('.destroy-button').forEach(elem => elem.style.display = type ? 'none' : '');
      setDisplay(type);
    }, [display],
  );

  return (
    <div className="uk-button-group" style={{ marginBottom: '10px' }}>
      <button onClick={handleClick(true)} className={`uk-button uk-button-primary ${!display ? ' uk-active' : '' }`}>非表示</button>
      <button onClick={handleClick(false)} className={`uk-button uk-button-danger ${display ? ' uk-active' : '' }`}>表示</button>
    </div>
  );
};

export default DestroyButtonDisplayToggle;
