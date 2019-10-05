import React from 'react';

interface IProps {
  bp: string;
  handleChangeBp: (e: React.ChangeEvent<HTMLInputElement>) => void;
}
const BpForm: React.SFC<IProps> = props => {
  const { bp, handleChangeBp } = props;
  return (
    <>
      <label className="label">指定したBP以上の楽曲に★マーク</label>
      <div className="control has-text-centered">
        <input
          className="input"
          type="text"
          value={bp}
          onChange={handleChangeBp}
          style={{ width: '50%' }}
        />
      </div>
    </>
  );
};

export default BpForm;
