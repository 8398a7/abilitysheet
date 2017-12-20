# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  username               :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  iidxid                 :string           not null
#  version                :integer          default(22), not null
#  djname                 :string           not null
#  grade                  :integer
#  pref                   :integer          not null
#  role                   :integer          default(0), not null
#  image                  :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

describe User, type: :model do
  describe '.belongs' do
    it "所属を配列で返すこと[['海外', 0], ['北海道', 1]..]" do
      pref = User::Static::PREF
      User.belongs.each { |p| expect(pref[p[1]]).to eq p[0] }
    end
  end
  describe '.dan' do
    it "段位を配列で返すこと[['皆伝', 0], ['中伝', 1], ['十段', 2]..]" do
      dan = User::Static::GRADE
      User.dan.each { |d| expect(dan[d[1]]).to eq d[0] }
    end
  end
  context 'validation' do
    it 'iidxid, version, djname, pref, grade, username, passwordがあれば有効な状態であること' do
      expect(create(:user)).to be_valid
    end
    it 'ユーザごとに重複したemailを許可しないこと' do
      create(:user, email: 'validate@iidx.tk')
      user = build(:user, iidxid: '9384-2982', username: 'test2', email: 'validate@iidx.tk')

      user.valid?
      expect(user.errors[:email]).to include('はすでに存在します。')
    end
    it 'emailがなければ無効な状態であること' do
      user = User.new(email: '')
      user.valid?
      expect(user.errors[:email]).to include('を入力してください。')
    end
    it 'ユーザごとに重複したiidxidを許可しないこと' do
      create(:user)
      user = build(:user, username: 'test2')

      user.valid?
      expect(user.errors[:iidxid]).to include('はすでに存在します。')
    end
    it 'iidxidがなければ無効な状態であること' do
      user = User.new(iidxid: nil)
      user.valid?
      expect(user.errors[:iidxid]).to include('を入力してください。')
    end
    it 'iidxidが9文字でなければ無効な状態であること' do
      (1..8).each do |num|
        iidxid = ''
        num.times { iidxid += '1' }
        user = build(:user, iidxid: iidxid)
        user.valid?
        expect(user.errors[:iidxid]).to include('は9文字で入力してください。')
      end
    end
    it 'iidxidの書式が正しくなければ無効な状態であること' do
      user = User.new(iidxid: '123456789')
      user.valid?
      expect(user.errors[:iidxid]).to include('が正しくありません。')
    end
    it 'djnameがなければ無効な状態であること' do
      user = User.new(djname: nil)
      user.valid?
      expect(user.errors[:djname]).to include('を入力してください。')
    end
    it 'djnameが半角大文字英字でなければ無効な状態であること' do
      user = User.new(djname: 'test')
      user.valid?
      expect(user.errors[:djname]).to include('は半角大文字英字で記入して下さい')
    end
    it 'djnameは6文字以内であれば有効であること' do
      (1..6).each do |num|
        djname = ''
        num.times { djname += 'A' }
        expect(build(:user, djname: djname)).to be_valid
      end
    end
    it 'prefがなければ無効な状態であること' do
      user = User.new(pref: nil)
      user.valid?
      expect(user.errors[:pref]).to include('を入力してください。')
    end
    it 'prefが0..47であれば有効な状態であること' do
      (0..47).each { |pref| expect(build(:user, pref: pref)).to be_valid }
    end
    it 'gradeがなければ無効な状態であること' do
      user = User.new(grade: nil)
      user.valid?
      expect(user.errors[:grade]).to include('を入力してください。')
    end
    it 'gradeが設定値..19であれば有効な状態であること' do
      set_value = Abilitysheet::Application.config.iidx_grade
      (set_value..19).each { |grade| expect(build(:user, grade: grade)).to be_valid }
    end
    it 'usernameがなければ無効な状態であること' do
      user = User.new(username: nil)
      user.valid?
      expect(user.errors[:username]).to include('を入力してください。')
    end
    it 'usernameは3-10文字であれば有効であること' do
      (3..10).each do |num|
        username = ''
        num.times { username += 'a' }
        expect(build(:user, username: username)).to be_valid
      end
    end
    it 'ユーザごとに重複したusernameを許可しないこと' do
      create(:user)
      user = build(:user, iidxid: '2345-6789')

      user.valid?
      expect(user.errors[:username]).to include('はすでに存在します。')
    end
    it 'passwordがなければ無効な状態であること' do
      user = User.new(password: nil)
      user.valid?
      expect(user.errors[:password]).to include('を入力してください。')
    end
    it 'passwordが8文字以上でなければ無効な状態であること' do
      (1..7).each do |num|
        password = ''
        num.times { password += 'a' }
        user = build(:user, password: password)
        user.valid?
        expect(user.errors[:password]).to include('は8文字以上で入力してください。')
      end
    end
  end
end
