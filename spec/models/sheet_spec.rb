describe Sheet, type: :model do
  context 'activeな楽曲がある場合' do
    before do
      create(:sheet, title: 'one', active: true)
      create(:sheet, title: 'two', active: true)
      create(:sheet, title: 'three')
    end
    describe '.active' do
      it 'アクティブな楽曲の数を返す' do
        expect(Sheet.active.count).to eq 2
      end
    end
  end
  context 'activeな楽曲がない場合' do
    before do
      create(:sheet, title: 'one')
    end
    describe '.active' do
      it '正しく0を返す' do
        expect(Sheet.active.count).to eq 0
      end
    end
  end
end
