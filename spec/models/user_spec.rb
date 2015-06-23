require 'rails_helper'

RSpec.describe User, type: :model do
  # クラスメソッド
  # 所属を配列で返すこと[['海外', 0], ['北海道', 1]..]
  it 'returns belongs information as array' do
    pref = %w(
      海外
      北海道 青森県   岩手県 宮城県
      秋田県 山形県   福島県 茨城県
      栃木県 群馬県   埼玉県 千葉県
      東京都 神奈川県 新潟県 富山県
      石川県 福井県   山梨県 長野県
      岐阜県 静岡県   愛知県 三重県
      滋賀県 京都府   大阪府 兵庫県
      奈良県 和歌山県 鳥取県 島根県
      岡山県 広島県   山口県 徳島県
      香川県 愛媛県   高知県 福岡県
      佐賀県 長崎県   熊本県 大分県
      宮崎県 鹿児島県 沖縄県
    )
    User.belongs.each { |p| expect(pref[p[1]]).to eq p[0] }
  end
  # 段位を配列で返すこと[['皆伝', 0], ['十段', 1]..]
  it 'returns grade information as array' do
    dan = %w(
      皆伝
      十段 九段
      八段 七段 六段 五段 四段 三段 二段 初段
      一級 二級 三級 四級 五級 六級 七級
    )
    User.dan.each { |d| expect(dan[d[1]]).to eq d[0] }
  end

  # バリデーション
  # iidxid, version, djname, pref, grade, username, passwordがあれば有効な状態であること
  it 'is valid with a iidxid, version, djname, grade, username and password' do
    expect(create(:user)).to be_valid
  end
  # ユーザごとに重複したiidxidを許可しないこと
  it 'does not allow duplicate iidxid per user' do
    create(:user)
    user = build(:user, username: 'test2')

    user.valid?
    expect(user.errors[:iidxid]).to include('はすでに存在します。')
  end
  # iidxidがなければ無効な状態であること
  it 'is invalid without a iidxid' do
    user = User.new(iidxid: nil)
    user.valid?
    expect(user.errors[:iidxid]).to include('を入力してください。')
  end
  # iidxidが9文字でなければ無効な状態であること
  it 'is invalid without a iidxid is not 9 characters' do
    (1..8).each do |num|
      iidxid = ''
      num.times { iidxid += '1' }
      user = build(:user, iidxid: iidxid)
      user.valid?
      expect(user.errors[:iidxid]).to include('は9文字で入力してください。')
    end
  end
  # iidxidの書式が正しくなければ無効な状態であること
  it 'is invalid without a iidxid format is incorrect' do
    user = User.new(iidxid: '123456789')
    user.valid?
    expect(user.errors[:iidxid]).to include('が正しくありません。')
  end
  # djnameがなければ無効な状態であること
  it 'is invalid without a djname' do
    user = User.new(djname: nil)
    user.valid?
    expect(user.errors[:djname]).to include('を入力してください。')
  end
  # djnameが半角大文字英字でなければ無効な状態であること
  it 'is invalid without a djname is not single-byte uppercase letters' do
    user = User.new(djname: 'test')
    user.valid?
    expect(user.errors[:djname]).to include('は半角大文字英字で記入して下さい')
  end
  # djnameは6文字以内であれば有効であること
  it 'is valid with a djname is less than 6 characters' do
    (1..6).each do |num|
      djname = ''
      num.times { djname += 'A' }
      expect(build(:user, djname: djname)).to be_valid
    end
  end
  # prefがなければ無効な状態であること
  it 'is invalid without a pref' do
    user = User.new(pref: nil)
    user.valid?
    expect(user.errors[:pref]).to include('を入力してください。')
  end
  # prefが0..47であれば有効な状態であること
  it 'is valid with a pref is 0-47' do
    (0..47).each { |pref| expect(build(:user, pref: pref)).to be_valid }
  end
  # gradeがなければ無効な状態であること
  it 'is invalid without a grade' do
    user = User.new(grade: nil)
    user.valid?
    expect(user.errors[:grade]).to include('を入力してください。')
  end
  # gradeが設定値..17であれば有効な状態であること
  it 'is valid with a grade is set value-17' do
    set_value = Abilitysheet::Application.config.iidx_grade
    (set_value..17).each { |grade| expect(build(:user, grade: grade)).to be_valid }
  end
  # usernameがなければ無効な状態であること
  it 'is invalid without a username' do
    user = User.new(username: nil)
    user.valid?
    expect(user.errors[:username]).to include('を入力してください。')
  end
  # usernameは3-10文字であれば有効であること
  it 'is valid with a username is 3-10 characters' do
    (3..10).each do |num|
      username = ''
      num.times { username += 'a' }
      expect(build(:user, username: username)).to be_valid
    end
  end
  # ユーザごとに重複したusernameを許可しないこと
  it 'does not allow duplicate username per user' do
    create(:user)
    user = build(:user, iidxid: '2345-6789')

    user.valid?
    expect(user.errors[:username]).to include('はすでに存在します。')
  end
  # passwordがなければ無効な状態であること
  it 'is invalid without a password' do
    user = User.new(password: nil)
    user.valid?
    expect(user.errors[:password]).to include('を入力してください。')
  end
  # passwordが8文字以上でなければ無効な状態であること
  it 'is invalid without a password is at least 8 characters' do
    (1..7).each do |num|
      password = ''
      num.times { password += 'a' }
      user = build(:user, password: password)
      user.valid?
      expect(user.errors[:password]).to include('は8文字以上で入力してください。')
    end
  end
end
