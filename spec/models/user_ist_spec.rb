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

require 'ist_client'

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
      expect(scores.find_by(sheet: Sheet.find_by(title: 'AA'))).to have_attributes(
        version: Abilitysheet::Application.config.iidx_version,
        state: 0,
        score: 3045,
        bp: 6
      )
      expect(user.logs.find_by(sheet_id: Sheet.find_by(title: 'AA'))).to have_attributes(
        version: Abilitysheet::Application.config.iidx_version,
        pre_state: 7,
        new_state: 0,
        pre_score: nil,
        new_score: 3045,
        pre_bp: nil,
        new_bp: 6
      )
    end
    it '存在しないユーザはraiseすること' do
      user.update!(iidxid: '1234-5678')
      VCR.use_cassette('not_found_ist') do
        expect { user.update_ist }.to raise_error IstClient::NotFoundUser
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
    describe '#update_user' do
      let(:instance) { create(:user, djname: 'HOGE', pref: 1, grade: 5) }
      it 'emojiユーザはdjnameだけ更新されないこと' do
        user = {
          'user_activity' => {
            'djname' => '♨',
            'pref_status' => '東京都',
            'sp_grade_status' => 'SP 八段'
          },
          'image_path' => 'https://score.iidx.app/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBclpJIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--7b255d5e81086f819b59e59c38debecaa6a6caba/avatar.png'
        }
        VCR.use_cassette('invalid_djname_ist') { instance.update_user(user) }
        expect(instance.pref).to eq 13
        expect(instance.grade).to eq 4
        expect(instance.djname).to eq 'HOGE'
      end
    end
  end
end
