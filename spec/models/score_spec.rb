require 'rails_helper'

RSpec.describe Score, type: :model do
  before do
    FactoryGirl.create(:sheet, id: 1, title: 'one', active: true)
    FactoryGirl.create(:sheet, id: 2, title: 'two', active: true)
    FactoryGirl.create(:sheet, id: 3, title: 'three')
    FactoryGirl.create(:user, id: 1)
    FactoryGirl.create(:score, id: 1, user_id: 1, sheet_id: 1, state: 6, updated_at: '2015-06-23 15:34')
    FactoryGirl.create(:score, id: 2, user_id: 1, sheet_id: 2, state: 7, updated_at: '2015-06-23 15:35')
    FactoryGirl.create(:score, id: 3, user_id: 1, sheet_id: 3, state: 7, updated_at: '2015-06-23 15:35')
  end

  context '.last_updated' do
    it '新しい順かつNOPLAYではないスコアを返す' do
      expect(User.find_by(id: 1).scores.last_updated.id).to eq 1
    end
  end

  context '.is_active' do
    it 'アクティブな楽曲のスコア一覧を返す' do
      expect(User.find_by(id: 1).scores.is_active.count).to eq 2
    end
  end

  context '#active?' do
    it 'activeな曲はtrueを返す' do
      expect(Score.find_by(id: 1).active?).to eq true
    end
    it 'inactiveな曲はfalseを返す' do
      expect(Score.find_by(id: 3).active?).to eq false
    end
  end

  context '#update_with_logs' do
    it 'logデータも作られている' do
      score_params = { 'sheet_id' => '1', 'state' => '5' }
      User.find_by(id: 1).scores.find_by(id: 1).update_with_logs(score_params)
      ret = {
        user_id: 1, sheet_id: 1,
        pre_state: 6, new_state: 5,
        pre_score: nil, new_score: nil,
        pre_bp: nil, new_bp: nil,
        version: 22
      }
      expect(User.find_by(id: 1).logs.exists?(ret)).to eq true
    end
    it 'stateが変化しない場合はlogを作らない' do
      score_params = { 'sheet_id' => '1', 'state' => '6' }
      User.find_by(id: 1).scores.find_by(id: 1).update_with_logs(score_params)
      expect(User.find_by(id: 1).logs.empty?).to eq true
    end
  end
end
