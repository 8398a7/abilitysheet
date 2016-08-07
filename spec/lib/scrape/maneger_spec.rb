# frozen_string_literal: true
describe 'lib/scrape/manager.rb' do
  let(:agent) { Mechanize.new }

  context '正常系' do
    it '登録されている場合は/sp/を含むページの配列を1つ返す' do
      user = build(:user, iidxid: '6570-6412')
      res = Scrape::Manager.new(user)
      expect(res.url.count).to eq 1
      expect(res.url.first).to include('/sp/')
    end
    it '複数登録されている場合は/sp/を含む複数配列を返す' do
      user = build(:user, iidxid: '9447-8955')
      res = Scrape::Manager.new(user)
      expect(res.url.count).to be >= 2
      res.url.each do |url|
        expect(url).to include('/sp/')
      end
    end
    it '正しく楽曲が反映されている' do
      sync_sheet
      user = create(:user, iidxid: '2222-2222')
      expect(Scrape::Manager.new(user).sync).to be_truthy
      (0..6).each do |state|
        expect(user.scores.where(state: state).count).to eq 1
      end
    end
    it '12フォルダが存在すればnokogiriのクラスを返す' do
      res = Scrape::Manager.new(build(:user, iidxid: '3223-5186'))
      html = Nokogiri::HTML.parse(
        agent.get('http://beatmania-clearlamp.com/djdata/lib_sheet/sp/').body,
        nil,
        'UTF-8'
      )
      expect(res.send(:folder_specific, html).is_a?(Nokogiri::XML::Element)).to be_truthy
    end
  end

  context '異常系' do
    let(:res) { Scrape::Manager.new(build(:user, iidxid: '4935-9422')) }
    it '登録されていない場合は空の配列を返す' do
      expect(res.url.empty?).to eq true
    end
    it '登録されていない場合はfalseを返す' do
      expect(res.sync).to eq false
    end
    it '登録されていない場合はfalseを返す' do
      expect(res.sync).to eq false
    end
    it 'Lv12フォルダがない場合はnilを返す' do
      html = Nokogiri::HTML.parse(
        agent.get('http://beatmania-clearlamp.com/djdata/ruquia7/sp/').body,
        nil,
        'UTF-8'
      )
      expect(res.send(:folder_specific, html)).to eq nil
    end
  end

  describe '#gigadelic_innocentwalls' do
    it 'incorrect' do
      res = Scrape::Manager.new(build(:user))
      expect(res.send(:gigadelic_innocentwalls, 'test', 'elem')).to include('test')
    end
    it 'correct' do
      res = Scrape::Manager.new(build(:user))
      elem = %(
        <dl class="731 hyper" style="background-image: url(http://beatmania-clearlamp.com/common/img/bg_mypage-music_on.png);">
        <dt class="EX"><span>.</span></dt>
        <dd class="level l12">.</dd>
        <dd class="musicName">gigadelic</dd>
        <dd class="exe">
        <form method="post" action="exe.php">
        <input type="hidden" name="userId" value="">
        <input type="hidden" name="musicId" value="731">
        <select name="lampId">
        <option value=""></option>
        <option value="1">FC</option>
        <option value="2" selected="selected">EX</option>
        <option value="3">H</option>
        <option value="4">C</option>
        <option value="5">E</option>
        <option value="6">A</option>
        <option value="7">F</option>
        <option value="8"></option>
        </select>
        </form>
        </dd>
        </dl>
      )
      expect(res.send(:gigadelic_innocentwalls, 'gigadelic', elem)).to include('gigadelic[H]')
    end
  end
  # HTMLの整形

  # 登録の正常判定
end
