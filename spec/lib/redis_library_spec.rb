describe 'lib/redis_library.rb' do
  before do
    @base_recent200 = JSON.parse(File.read("#{Rails.root}/spec/mock/users/recent200.json"))
    Redis.new.set(:recent200, @base_recent200.to_json)
    create(:user, id: 1)
    create(:score, id: 1, user_id: 1, sheet_id: 1, state: 0)
    create(:sheet, id: 1, title: 'redis library')
  end

  context 'スコアの状態が変化しない時' do
    it 'SQLが発行されない時はredisの状態も変わらない' do
      Score.first.update(state: 0)
      expect(Redis.new.get(:recent200)).to eq @base_recent200.to_json
    end
  end

  context 'スコアの状態が変化する時' do
    it 'SQLが発行された時はredisの状態も変化する' do
      Score.first.update(state: 1)
      expect(Redis.new.get(:recent200)).to_not eq @base_recent200.to_json
    end

    it '最後にredisに追加されたユーザから削除されていく' do
      JSON.parse(Redis.new.get(:recent200)).each_value { |v| expect(v['djname']).to_not eq 'TEST' }
      (2..201).each do |i|
        create(:user, id: i, iidxid: format('0000-%04d', i), username: format('test%d', i))
        create(:score, id: i, user_id: i, sheet_id: 1, state: 0)
        last_key = nil
        recent200 = JSON.parse(Redis.new.get(:recent200))
        recent200.each_key { |k| last_key = k }
        expect(recent200.key?(last_key)).to eq true
        Score.find(i - 1).update(state: 1)
        recent200 = JSON.parse(Redis.new.get(:recent200))
        expect(recent200.key?(last_key)).to eq false
        expect(recent200.key?(User.find(i - 1).id.to_s)).to eq true
        expect(recent200.first[0]).to eq User.find(i - 1).id.to_s
      end
      JSON.parse(Redis.new.get(:recent200)).each_value { |v| expect(v['djname']).to eq 'TEST' }
    end
  end
end
