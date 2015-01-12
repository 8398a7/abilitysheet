require 'rails_helper'

describe 'lib/scrape/maneger.rb' do
  # 登録されていない場合は空の配列を返す
  it 'returns if is not registered empty array' do
    user = build(:user)
    res = Scrape::Maneger.new(user)
    expect(res.url.empty?).to eq true
  end
  # 登録されている場合は/sp/を含むページの配列を1つ返す
  it 'returns if is registered include /sp/ array' do
    user = build(:user, iidxid: '6570-6412')
    res = Scrape::Maneger.new(user)
    expect(res.url.count).to eq 1
    expect(res.url.first).to include('/sp/')
  end
  # 複数登録されている場合は/sp/を含む複数配列を返す
  it 'returns if is registered include /sp/ some array' do
    user = build(:user, iidxid: '9447-8955')
    res = Scrape::Maneger.new(user)
    expect(res.url.count).to be >= 2
    res.url.each do |url|
      expect(url).to include('/sp/')
    end
  end
  # 登録されていない場合はfalseを返す
  it 'returns if is not registered does not include /sp/' do
    user = build(:user)
    res = Scrape::Maneger.new(user)
    expect(res.sync).to eq false
  end
  # extractメソッドで12フォルダがないときのテスト
  # 全て一から問題なく通ることの確認のテスト
end
