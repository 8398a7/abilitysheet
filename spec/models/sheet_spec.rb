require 'rails_helper'

RSpec.describe Sheet, type: :model do
  context 'activeな楽曲がある場合' do
    before do
      FactoryGirl.create(:sheet, title: 'one', active: true)
      FactoryGirl.create(:sheet, title: 'two', active: true)
      FactoryGirl.create(:sheet, title: 'three')
    end
    it '.active' do
      expect(Sheet.active.count).to eq 2
    end
  end
  context 'activeな楽曲がない場合' do
    before do
      FactoryGirl.create(:sheet, title: 'one')
    end
    it '.active' do
      expect(Sheet.active.count).to eq 0
    end
  end
end
