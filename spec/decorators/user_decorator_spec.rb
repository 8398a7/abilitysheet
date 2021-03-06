# frozen_string_literal: true

describe UserDecorator do
  let(:instance) { described_class.new(user) }

  let(:user) { create(:user, created_at: Time.new(2017, 3, 3)) }

  describe '#pref' do
    it 'returns pref of its pref' do
      expect(instance.pref).to eq('海外')
    end
  end

  describe '#grade' do
    it 'returns dan grade of its grade' do
      expect(instance.grade).to eq(User::Static::GRADE[Abilitysheet::Application.config.iidx_grade])
    end
  end

  describe '#belongs' do
    it 'returns belongs of its pref' do
      expect(instance.belongs).to eq('海外')
    end
  end

  describe '#dan' do
    it 'returns dan of its grade' do
      expect(instance.dan).to eq(User::Static::GRADE[Abilitysheet::Application.config.iidx_grade])
    end
  end

  describe '#dan_color' do
    it 'returns dan color of its grade' do
      expect(instance.dan_color).to eq(User::Static::GRADE_COLOR[Abilitysheet::Application.config.iidx_grade])
    end
  end

  describe '#joined_on' do
    it 'returns joined on format' do
      expect(instance.joined_on).to eq('Joined on 2017/03/03')
    end
  end
end
