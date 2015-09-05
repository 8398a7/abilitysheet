# == Schema Information
#
# Table name: logs
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  sheet_id   :integer
#  pre_state  :integer
#  new_state  :integer
#  pre_score  :integer
#  new_score  :integer
#  pre_bp     :integer
#  new_bp     :integer
#  version    :integer
#  created_at :date
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
      before { create(:log, user_id: 1, sheet_id: 1, created_at: Date.today - 1, pre_state: 7, new_state: 6) }
      it 'ログデータが作られる' do
        create(:score, user_id: 1, sheet_id: 1, state: 6)
        expect { user.logs.attributes(parameter, user) }.to change(Log, :count).by(1)
        expect(user.logs.exists?(sheet_id: 1, pre_state: 7, new_state: 6)).to eq true
        expect(user.logs.exists?(sheet_id: 1, pre_state: 6, new_state: 5)).to eq true
      end
    end
  end
end
