require 'rails_helper'

describe Sheet do
  # activeな楽曲群を返す
  it 'returns active sheets' do
    Sheet.active.each do |sheet|
      expect(sheet.active).to eq true
    end
  end
end
