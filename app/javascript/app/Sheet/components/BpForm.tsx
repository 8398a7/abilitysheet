import * as React from 'react';

interface IProps {
  bp: string;
  handleChangeBp: (e: React.ChangeEvent<HTMLInputElement>) => void;
}
const BpForm: React.SFC<IProps> = (props) => {
  const { bp, handleChangeBp } = props;
  return (
    <form className="uk-form uk-form-stacked">
      <label className="uk-form-label">指定したBP以上の楽曲に★マーク</label>
      <div className="uk-form-controls">
        <input type="text" value={bp} onChange={handleChangeBp} />
      </div>
    </form>
  );
};

export default BpForm;
