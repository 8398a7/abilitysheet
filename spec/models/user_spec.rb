# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
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
#  rival                  :text
#  reverse_rival          :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  role                   :integer          default(0), not null
#  email                  :string           default(""), not null
#

describe User, type: :model do
  describe '#add_rival' do
    before do
      (1..12).each do |i|
        create(:user, id: i, iidxid: format('0000-%04d', i), username: format('test%d', i))
      end
    end

    context 'ライバル機能を使っていないユーザ同士' do
      let(:user) { User.find_by(id: 1) }
      let(:target) { User.find_by(id: 2) }
      context 'ライバルに登録' do
        before { user.add_rival(target.iidxid) }
        it '自身のライバルに追加されている' do
          expect(user.rival).to include(target.iidxid)
        end
        it '相手の逆ライバルに追加されている' do
          target.reload
          expect(target.reverse_rival).to include(user.iidxid)
        end
      end
      describe '既にライバル登録済みのユーザをライバルにしようとする' do
        before { user.add_rival(target.iidxid) }
        it 'falseを返す' do
          expect(user.add_rival(target.iidxid)).to eq false
        end
        it 'ライバル数，逆ライバル数は1のままである' do
          target.reload
          expect(user.rival.count).to eq 1
          expect(target.reverse_rival.count).to eq 1
        end
      end
    end

    context '自身がライバルの機能を使っていて，相手は使っていない' do
      let(:user) { User.find_by(id: 1) }
      let(:target) { User.find_by(id: 2) }
      let(:sub) { User.find_by(id: 3) }
      before do
        user.add_rival(sub.iidxid)
        user.add_rival(target.iidxid)
      end
      it '自身のライバルに追加されている' do
        expect(user.rival).to include(target.iidxid)
      end
      it '相手の逆ライバルに追加されている' do
        target.reload
        expect(target.reverse_rival).to include(user.iidxid)
      end
    end

    describe '10人までライバル登録ができる' do
      let(:user) { User.find_by(id: 1) }
      before do
        (2..11).each do |i|
          user.add_rival(User.find_by(id: i).iidxid)
        end
      end
      it 'ライバル数10を返す' do
        expect(user.rival.count).to eq 10
      end
      it 'それぞれのターゲットの逆ライバルに自身が存在する' do
        (2..11).each do |i|
          expect(User.find_by(id: i).reverse_rival).to include(user.iidxid)
        end
      end
    end

    describe '10人以上はライバル登録ができない' do
      let(:user) { User.find_by(id: 1) }
      before do
        (2..11).each do |i|
          user.add_rival(User.find_by(id: i).iidxid)
        end
      end
      it 'falseを返す' do
        expect(user.add_rival(User.find_by(id: 12).iidxid)).to eq false
      end
      it 'ライバル数は10のままである' do
        expect(user.rival.count).to eq 10
      end
    end
  end

  describe '#remove_rival' do
    before do
      (1..12).each { |i| create(:user, id: i, iidxid: format('0000-%04d', i), username: format('test%d', i)) }
    end
    let(:user) { User.find_by(id: 1) }
    let(:target) { User.find_by(id: 2) }
    describe 'ライバルに登録し，削除する' do
      before do
        user.add_rival(target.iidxid)
        user.remove_rival(target.iidxid)
      end
      it 'ユーザのライバルは空の配列である' do
        expect(user.rival).to eq []
      end
      it 'ターゲットの逆ライバルは空の配列である' do
        target.reload
        expect(target.reverse_rival).to eq []
      end
    end
    describe '登録していないユーザを削除しようとする' do
      it 'falseを返す' do
        expect(user.remove_rival(target.iidxid)).to eq false
      end
      it 'ユーザのライバルはnilである' do
        expect(user.rival).to eq nil
      end
      it 'ターゲットの逆ライバルはnilである' do
        target.reload
        expect(target.reverse_rival).to eq nil
      end
    end
  end

  describe '.belongs' do
    it "所属を配列で返すこと[['海外', 0], ['北海道', 1]..]" do
      pref = Static::PREF
      User.belongs.each { |p| expect(pref[p[1]]).to eq p[0] }
    end
  end
  describe '.dan' do
    it "段位を配列で返すこと[['皆伝', 0], ['十段', 1]..]" do
      dan = Static::GRADE
      User.dan.each { |d| expect(dan[d[1]]).to eq d[0] }
    end
  end
  context 'validation' do
    it 'iidxid, version, djname, pref, grade, username, passwordがあれば有効な状態であること' do
      expect(create(:user)).to be_valid
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
    it 'gradeが設定値..17であれば有効な状態であること' do
      set_value = Abilitysheet::Application.config.iidx_grade
      (set_value..17).each { |grade| expect(build(:user, grade: grade)).to be_valid }
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
