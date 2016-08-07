# frozen_string_literal: true
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
    create(:score, id: 1, user_id: 1, sheet_id: 1, state: 7, updated_at: '2015-06-23 15:34')
    create(:score, id: 2, user_id: 1, sheet_id: 2, state: 7, updated_at: '2015-06-23 15:35')
    create(:score, id: 3, user_id: 1, sheet_id: 3, state: 7, updated_at: '2015-06-23 15:35')
    Score.find(1).update_with_logs(sheet_id: 1, state: 6, score: 100, bp: 5)
  end

  describe '#remain' do
    it '未難の数を正しく返す' do
      expect(@user.scores.remain(:hard)).to eq Sheet.active.count
      Score.find(1).update!(state: 5)
      expect(@user.scores.remain(:hard)).to eq Sheet.active.count
      Score.find(1).update!(state: 2)
      expect(@user.scores.remain(:hard)).to eq Sheet.active.count - 1
      expect(@user.scores.remain_string(:hard)).to eq "☆12ハード参考表(未難#{Sheet.active.count - 1})"
    end
    it '未クリアの数を正しく返す' do
      expect(@user.scores.remain(:clear)).to eq Sheet.active.count
      Score.find(1).update!(state: 6)
      expect(@user.scores.remain(:clear)).to eq Sheet.active.count
      Score.find(1).update!(state: 4)
      expect(@user.scores.remain(:clear)).to eq Sheet.active.count - 1
      expect(@user.scores.remain_string(:clear)).to eq "☆12ノマゲ参考表(未クリア#{Sheet.active.count - 1})"
    end
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
      @user.scores.find_by(id: 1).update_with_logs(sheet_id: 1, state: 5)
      ret = {
        user_id: 1, sheet_id: 1,
        pre_state: 7, new_state: 5,
        pre_score: nil, new_score: 100,
        pre_bp: nil, new_bp: 5
      }
      expect(@user.logs.exists?(ret)).to eq true
    end
    it '状態が変化しない場合はupdateされない' do
      score_params = { 'sheet_id' => '1', 'state' => '6' }
      expect(@user.scores.find_by(id: 1).update_with_logs(score_params)).to be_falsy
    end
    context '一部の状態が変化する場合' do
      it 'scoreのみが変化する' do
        expect(@user.logs.exists?(sheet_id: 1, pre_state: 7, new_state: 6, new_score: 100, new_bp: 5)).to be_truthy
        @user.scores.find_by(id: 1).update_with_logs(sheet_id: 1, state: 6, score: 101, bp: 5)
        expect(@user.logs.exists?(sheet_id: 1, pre_state: 7, new_state: 6, pre_score: nil, new_score: 101, new_bp: 5)).to be_truthy
      end
      it 'bpのみが変化する' do
        expect(@user.logs.exists?(sheet_id: 1, pre_state: 7, new_state: 6, new_score: 100, new_bp: 5)).to be_truthy
        @user.scores.find_by(id: 1).update_with_logs(sheet_id: 1, state: 6, score: 100, bp: 101)
        expect(@user.logs.exists?(sheet_id: 1, pre_state: 7, new_state: 6, pre_bp: nil, new_bp: 101)).to be_truthy
      end
    end
  end

  context 'validate' do
    it '一つのバージョンでユーザは同じ楽曲を複数持たない' do
      expect do
        Score.create(id: 99, user_id: 99, sheet_id: 1, version: 1)
        Score.create(id: 100, user_id: 99, sheet_id: 1, version: 1)
      end.to change(Score, :count).by(1)
    end
  end
end
