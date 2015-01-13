require 'rails_helper'

describe Sheet do
  # activeな楽曲群を返す
  it 'returns active sheets' do
    Sheet.active.each do |sheet|
      expect(sheet.active).to eq true
    end
  end
  # 地力値を配列で返すこと[['地力S', 0], ['個人差S+', 1]..]
  it 'returns music power as array' do
    power = [['地力S+', 0],
             ['個人差S+', 1],
             ['地力S', 2],
             ['個人差S', 3],
             ['地力A+', 4],
             ['個人差A+', 5],
             ['地力A', 6],
             ['個人差A', 7],
             ['地力B+', 8],
             ['個人差B+', 9],
             ['地力B', 10],
             ['個人差B', 11],
             ['地力C', 12],
             ['個人差C', 13],
             ['地力D', 14],
             ['個人差D', 15],
             ['地力E', 16],
             ['個人差E', 17],
             ['地力F', 18],
             ['難易度未定', 19]]
    Sheet.power.each_with_index { |s, i| expect(s).to eq power[i] }
  end
end
