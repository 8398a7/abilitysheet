# frozen_string_literal: true

# == Schema Information
#
# Table name: logs
#
#  id           :bigint(8)        not null, primary key
#  user_id      :bigint(8)
#  sheet_id     :bigint(8)
#  pre_state    :integer
#  new_state    :integer
#  pre_score    :integer
#  new_score    :integer
#  pre_bp       :integer
#  new_bp       :integer
#  version      :integer
#  created_date :date
#
# Indexes
#
#  index_logs_on_created_date_and_user_id_and_sheet_id  (created_date,user_id,sheet_id) UNIQUE
#  index_logs_on_sheet_id                               (sheet_id)
#  index_logs_on_user_id                                (user_id)
#

describe Log, type: :model do
  describe '.cleanup!' do
    before do
      create(:user, id: 1)
      create(:sheet, id: 1)
      create(:log, id: 1, user_id: 1, sheet_id: 1, pre_bp: 22, new_bp: 25, pre_score: 140, new_score: 120, created_date: '2000-01-01')
      create(:log, id: 2, user_id: 1, sheet_id: 1, pre_bp: 22, new_bp: 20, pre_score: 140, new_score: 140, created_date: '2000-01-02')
      create(:log, id: 3, user_id: 1, sheet_id: 1, pre_bp: 22, new_bp: 15, pre_score: 140, new_score: 160, created_date: '2000-01-03')
    end
    it 'ログデータのスコアが正しい数値に整形される' do
      User.find(1).logs.cleanup!(Abilitysheet::Application.config.iidx_version)
      expect(Log.exists?(id: 1, pre_bp: 22, new_bp: 25, pre_score: 140, new_score: 120)).to eq true
      expect(Log.exists?(id: 2, pre_bp: 25, new_bp: 20, pre_score: 120, new_score: 140)).to eq true
      expect(Log.exists?(id: 3, pre_bp: 20, new_bp: 15, pre_score: 140, new_score: 160)).to eq true
    end
  end
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
      before { create(:log, user_id: user.id, sheet_id: 1, created_date: Date.today - 1, pre_state: 7, new_state: 6) }
      it 'ログデータが作られる' do
        create(:score, user_id: user.id, sheet_id: 1, state: 6)
        expect { user.logs.attributes(parameter, user) }.to change(Log, :count).by(1)
        expect(user.logs.exists?(sheet_id: 1, pre_state: 7, new_state: 6)).to eq true
        expect(user.logs.exists?(sheet_id: 1, pre_state: 6, new_state: 5)).to eq true
      end
    end
  end

  describe '.prev_next' do
    let(:sheet) { create(:sheet) }
    let(:user) { create(:user) }
    let(:user2) { create(:user, username: 'user2', iidxid: '9999-9999') }
    before do
      create(:log, created_date: '2015/09/30', user_id: user.id, sheet_id: sheet.id)
      create(:log, created_date: '2015/08/30', user_id: user2.id, sheet_id: sheet.id)
      create(:log, created_date: '2015/07/30', user_id: user.id, sheet_id: sheet.id)
      create(:log, created_date: '2015/07/20', user_id: user2.id, sheet_id: sheet.id)
      create(:log, created_date: '2015/06/30', user_id: user.id, sheet_id: sheet.id)
    end
    it '間に他のユーザのデータが有ってもログの前後関係が正しい' do
      expect(Log.prev_next(user.id, '2015/07/30')).to eq ['2015/06/30'.to_date, '2015/09/30'.to_date]
    end
    it '先頭のデータの場合，prevにnilを返す' do
      expect(Log.prev_next(user.id, '2015/06/30')).to eq [nil, '2015/07/30'.to_date]
    end
    it '末尾のデータの場合，nextにnilを返す' do
      expect(Log.prev_next(user.id, '2015/09/30')).to eq ['2015/07/30'.to_date, nil]
    end
  end
end
