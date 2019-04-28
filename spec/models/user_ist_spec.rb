# frozen_string_literal: true

# == Schema Information
#
# Table name: follows
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  target_user_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

describe User::Ist, type: :model do
  describe '#update_ist' do
    let(:user) { create(:user, grade: 18, iidxid: '8594-9652', djname: 'HOGE', pref: 0) }
    it '同期できる' do
      VCR.use_cassette('sync_sheet') do
        RedisHelper.load_sheets_data
        sync_sheet
      end
      expect(user.avatar.attached?).to be_falsey
      VCR.use_cassette('ist') do
        user.update_ist
      end
      expect(user.avatar.attached?).to be_truthy
      expect(user.djname).to eq '839'
      expect(user.grade).to eq 4
      expect(user.pref).to eq 37
      scores = user.scores.is_current_version
      expect(scores.find_by(sheet: Sheet.find_by(title: '東京神話'))).to have_attributes(
        version: Abilitysheet::Application.config.iidx_version,
        state: 2,
        score: 2394,
        bp: 34
      )
      expect(user.logs.find_by(sheet_id: Sheet.find_by(title: '東京神話'))).to have_attributes(
        version: Abilitysheet::Application.config.iidx_version,
        pre_state: 7,
        new_state: 2,
        pre_score: nil,
        new_score: 2394,
        pre_bp: nil,
        new_bp: 34
      )
      expect(scores.find_by(sheet: Sheet.find_by(title: 'Go Beyond!!'))).to have_attributes(
        version: Abilitysheet::Application.config.iidx_version,
        state: 2,
        score: 0,
        bp: 0
      )
    end
    it '存在しないユーザはfalseが返ること' do
      user.update!(iidxid: '1234-5678')
      VCR.use_cassette('not_found_ist') do
        expect(user.update_ist).to eq false
      end
    end
  end
  context 'module method' do
    let(:test_class) { Struct.new(:test_class) { include User::Ist } }
    let(:instance) { test_class.new }
    describe '#find_pref' do
      it('海外なら0を返すこと') { expect(instance.find_pref('海外')).to eq 0 }
      it('北海道なら1を返すこと') { expect(instance.find_pref('北海道')).to eq 1 }
      it('香川県なら37を返すこと') { expect(instance.find_pref('香川県')).to eq 37 }
      it('沖縄県なら47を返すこと') { expect(instance.find_pref('沖縄県')).to eq 47 }
      it('香港なら0を返すこと') { expect(instance.find_pref('香港')).to eq 0 }
    end
    describe '#find_grade' do
      it('SP --なら19を返すこと') { expect(instance.find_grade('SP --')).to eq 19 }
      it('SP 七級なら18を返すこと') { expect(instance.find_grade('SP 七級')).to eq 18 }
      it('SP 中伝なら1を返すこと') { expect(instance.find_grade('SP 中伝')).to eq 1 }
      it('SP 皆伝なら0を返すこと') { expect(instance.find_grade('SP 皆伝')).to eq 0 }
    end
  end
end
