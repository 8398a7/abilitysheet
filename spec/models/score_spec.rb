# == Schema Information
#
# Table name: scores
#
#  id         :integer          not null, primary key
#  state      :integer          default(7), not null
#  score      :integer
#  bp         :integer
#  sheet_id   :integer          not null
#  user_id    :integer          not null
#  version    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

describe Score, type: :model do
  before do
    create(:sheet, id: 1, title: 'one', active: true)
    create(:sheet, id: 2, title: 'two', active: true)
    create(:sheet, id: 3, title: 'three')
    @user = create(:user, id: 1)
    create(:score, id: 1, user_id: 1, sheet_id: 1, state: 6, updated_at: '2015-06-23 15:34')
    create(:score, id: 2, user_id: 1, sheet_id: 2, state: 7, updated_at: '2015-06-23 15:35')
    create(:score, id: 3, user_id: 1, sheet_id: 3, state: 7, updated_at: '2015-06-23 15:35')
  end

  describe '.last_updated' do
    it '新しい順かつNOPLAYではないスコアを返す' do
      expect(@user.scores.last_updated.id).to eq 1
    end
  end

  describe '.is_active' do
    it 'アクティブな楽曲のスコア一覧を返す' do
      expect(@user.scores.is_active.count).to eq 2
    end
  end

  describe '#active?' do
    it 'activeな曲はtrueを返す' do
      expect(Score.find_by(id: 1).active?).to eq true
    end
    it 'inactiveな曲はfalseを返す' do
      expect(Score.find_by(id: 3).active?).to eq false
    end
  end

  describe '#update_with_logs' do
    it 'logデータも作られている' do
      score_params = { 'sheet_id' => '1', 'state' => '5' }
      @user.scores.find_by(id: 1).update_with_logs(score_params)
      ret = {
        user_id: 1, sheet_id: 1,
        pre_state: 6, new_state: 5,
        pre_score: nil, new_score: nil,
        pre_bp: nil, new_bp: nil,
        version: 22
      }
      expect(@user.logs.exists?(ret)).to eq true
    end
    it 'stateが変化しない場合はlogを作らない' do
      score_params = { 'sheet_id' => '1', 'state' => '6' }
      @user.scores.find_by(id: 1).update_with_logs(score_params)
      expect(@user.logs.count).to eq 0
    end
    it '状態が変化しない場合はupdateされない' do
      score_params = { 'sheet_id' => '1', 'state' => '6' }
      expect(@user.scores.find_by(id: 1).update_with_logs(score_params)).to be_falsy
    end
  end
end
