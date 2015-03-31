require 'rails_helper'

RSpec.describe Scrape::IIDXME do
  before(:all) do
    @user = User.first
    @iidxme = Scrape::IIDXME.new
  end

  context '存在するIIDXIDで実行した場合' do
    before(:all) do
      @iidxid = '7289-4932'
      @user.update(iidxid: @iidxid)
    end

    it '全体の処理が行った時にtrueを返す' do
      res = @iidxme.async(@iidxid)
      expect(res).to eq true
    end
  end
  context '存在しないIIDXIDで実行した場合' do
    before(:all) do
      @iidxid = '0000-0000'
      @user.update(iidxid: @iidxid)
    end
    it '全体の処理を行った時にfalseを返す' do
    end
  end
end
