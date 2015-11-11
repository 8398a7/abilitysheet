# == Schema Information
#
# Table name: logs
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  sheet_id     :integer
#  pre_state    :integer
#  new_state    :integer
#  pre_score    :integer
#  new_score    :integer
#  pre_bp       :integer
#  new_bp       :integer
#  version      :integer
#  created_date :date
#

describe Log, type: :model do
  describe '.attributes' do
    before { create(:sheet, id: 1) }
    let(:parameter) do
      { 'sheet_id' => 1, 'state' => 5 }
    end
    let(:user) { create(:user, id: 1) }
    context '初めての更新の場合' do
      it 'ログデータが作られる' do
        expect { user.logs.attributes(parameter, user) }.to change(Log, :count).by(1)
        expect(user.logs.exists?(sheet_id: 1, pre_state: 7, new_state: 5)).to eq true
      end
    end

    context '同日に同じ楽曲を更新する場合' do
      before { user.logs.attributes(parameter, user) }
      it 'ログデータは更新される' do
        expect { user.logs.attributes({ 'sheet_id' => 1, 'state' => 0 }, user) }.to change(Log, :count).by(0)
        expect(user.logs.exists?(sheet_id: 1, pre_state: 7, new_state: 0)).to eq true
      end
    end

    context '違う日に同じ楽曲を更新する場合' do
      before { create(:log, user_id: 1, sheet_id: 1, created_date: Date.today - 1, pre_state: 7, new_state: 6) }
      it 'ログデータが作られる' do
        create(:score, user_id: 1, sheet_id: 1, state: 6)
        expect { user.logs.attributes(parameter, user) }.to change(Log, :count).by(1)
        expect(user.logs.exists?(sheet_id: 1, pre_state: 7, new_state: 6)).to eq true
        expect(user.logs.exists?(sheet_id: 1, pre_state: 6, new_state: 5)).to eq true
      end
    end
  end

  describe '.prev_next' do
    before do
      create(:log, created_date: '2015/09/30', user_id: 1)
      create(:log, created_date: '2015/08/30', user_id: 2)
      create(:log, created_date: '2015/07/30', user_id: 1)
      create(:log, created_date: '2015/07/20', user_id: 2)
      create(:log, created_date: '2015/06/30', user_id: 1)
    end
    it '間に他のユーザのデータが有ってもログの前後関係が正しい' do
      expect(Log.prev_next(1, '2015/07/30')).to eq ['2015/06/30'.to_date, '2015/09/30'.to_date]
    end
    it '先頭のデータの場合，prevにnilを返す' do
      expect(Log.prev_next(1, '2015/06/30')).to eq [nil, '2015/07/30'.to_date]
    end
    it '末尾のデータの場合，nextにnilを返す' do
      expect(Log.prev_next(1, '2015/09/30')).to eq ['2015/07/30'.to_date, nil]
    end
  end
end
