import React from 'react';

interface IProps {
  name: string;
  handleChangeName: (e: React.ChangeEvent<HTMLInputElement>) => void;
}
const FilterNameForm: React.SFC<IProps> = ({ name, handleChangeName }) => {
  return (
    <>
      <label className="label">楽曲名フィルター</label>
      <div className="control has-text-centered">
        <input
          className="input"
          type="text"
          value={name}
          onChange={handleChangeName}
          style={{ width: '50%' }}
        />
      </div>
    </>
  );
};

export default FilterNameForm;
