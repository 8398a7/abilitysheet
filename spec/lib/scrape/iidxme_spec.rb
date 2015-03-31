require 'rails_helper'

RSpec.describe Scrape::IIDXME do
  let(:user) { FactoryGirl.create(:user, iidxid) }
  let(:iidxme) { Scrape::IIDXME.new }

  context '正常系' do
    describe '存在するIIDXIDで処理を行う場合' do
      let(:iidxid) { { iidxid: '7289-4932' } }
      it '#async' do
        expect(iidxme.async(user.iidxid)).to be_truthy
      end
      it '#process' do
        expect(iidxme.send(:process, user.iidxid)).to be_truthy
      end
      it '#user_id_search' do
        expect(iidxme.send(:user_id_search, user.iidxid).class).to eq String
      end
      it '#data_get' do
        expect(iidxme.send(:data_get, user.iidxid).class).to eq Hash
      end
    end
  end
  context '異常系' do
    describe 'IIDXIDの書式が正しくない場合' do
      let(:iidxids) { ['1', '1110'] }
      it '#async' do
        iidxids.each { |iidxid| expect(iidxme.async(iidxid)).to be_falsy }
      end
      it '#process' do
        iidxids.each { |iidxid| expect(iidxme.send(:process, iidxid)).to be_falsy }
      end
      it '#user_id_search' do
        iidxids.each { |iidxid| expect(iidxme.send(:user_id_search, iidxid)).to be_falsy }
      end
      it '#data_get' do
        iidxids.each { |iidxid| expect(iidxme.send(:data_get, iidxid)).to be_falsy }
      end
    end
    describe '存在しないIIDXIDで処理を行う場合' do
      let(:iidxid) { { iidxid: '0000-0000' } }
      it '#async' do
        expect(iidxme.async(user.iidxid)).to be_falsy
      end
      it '#process' do
        expect(iidxme.send(:process, user.iidxid)).to be_falsy
      end
      it '#user_id_search' do
        expect(iidxme.send(:user_id_search, user.iidxid)).to be_falsy
      end
      it '#data_get' do
        expect(iidxme.send(:data_get, user.iidxid)).to be_falsy
      end
    end
  end
end
