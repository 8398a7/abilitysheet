import React from 'react';

interface IProps {
  name: string;
  handleChangeName: (e: React.ChangeEvent<HTMLInputElement>) => void;
}
const FilterNameForm: React.SFC<IProps> = ({ name, handleChangeName }) => {
  return (
    <form className="uk-form uk-form-stacked">
      <label className="uk-form-label">楽曲名フィルター</label>
      <div className="uk-form-controls">
        <input type="text" value={name} onChange={handleChangeName} />
      </div>
    </form>
  );
};

export default FilterNameForm;
