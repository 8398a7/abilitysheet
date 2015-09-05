describe UserDecorator do
  let(:instance) { described_class.new(user) }

  let(:user) { create(:user) }

  describe '#pref' do
    it 'returns pref of its pref' do
      expect(instance.pref).to eq('海外')
    end
  end

  describe '#grade' do
    it 'returns dan grade of its grade' do
      expect(instance.grade).to eq('皆伝')
    end
  end

  describe '#belongs' do
    it 'returns belongs of its pref' do
      expect(instance.belongs).to eq('海外')
    end
  end

  describe '#dan' do
    it 'returns dan of its grade' do
      expect(instance.dan).to eq('皆伝')
    end
  end

  describe '#dan_color' do
    it 'returns dan color of its grade' do
      expect(instance.dan_color).to eq('#ffd900')
    end
  end
end
