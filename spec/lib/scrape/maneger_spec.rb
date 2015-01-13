require 'rails_helper'

describe 'lib/scrape/maneger.rb' do
  # 登録されていない場合は空の配列を返す
  it 'returns empty array if is not registered' do
    user = build(:user)
    res = Scrape::Maneger.new(user)
    expect(res.url.empty?).to eq true
  end
  # 登録されている場合は/sp/を含むページの配列を1つ返す
  it 'returns array if is registered include /sp/' do
    user = build(:user, iidxid: '6570-6412')
    res = Scrape::Maneger.new(user)
    expect(res.url.count).to eq 1
    expect(res.url.first).to include('/sp/')
  end
  # 複数登録されている場合は/sp/を含む複数配列を返す
  it 'returns some array if is registered include /sp/' do
    user = build(:user, iidxid: '9447-8955')
    res = Scrape::Maneger.new(user)
    expect(res.url.count).to be >= 2
    res.url.each do |url|
      expect(url).to include('/sp/')
    end
  end
  # 登録されていない場合はfalseを返す
  it 'returns false if is not registered does not include /sp/' do
    user = build(:user)
    res = Scrape::Maneger.new(user)
    expect(res.sync).to eq false
  end
  # Lv12フォルダがない場合はfalseを返す
  it 'returns false if is not level 12 folder' do
    res = Scrape::Maneger.new(build(:user))
    expect(res.extract('djdata/ruquia7/sp/')).to eq false
  end
  # 全て一から問題なく通ることの確認のテスト
  it 'returns true if is all correct' do
    res = Scrape::Maneger.new(build(:user, iidxid: '3223-5186'))
    expect(res.sync).to eq true
  end
  # elemsの要素を書いて期待通りの動きをしているかチェック
end
