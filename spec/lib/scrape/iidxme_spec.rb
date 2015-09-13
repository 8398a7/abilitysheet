describe Scrape::IIDXME do
  let(:user) { create(:user, id: 1, iidxid: iidxid) }
  let(:iidxme) { Scrape::IIDXME.new }

  context '正常系' do
    describe '存在するIIDXIDで処理を行う場合' do
      let(:iidxid) { '8594-9652' }
      it '#async' do
        create(:sheet, id: 1, title: 'F')
        create(:score, id: 1, user_id: 1, sheet_id: 1)
        expect(Score.find(1).state).to eq 7
        expect(Score.find(1).score).to eq nil
        expect(Score.find(1).bp).to eq nil
        expect(iidxme.async(user.iidxid)).to be_truthy
        expect(Score.find(1).state).to eq 0
        expect(Score.find(1).score).not_to eq nil
        expect(Score.find(1).bp).not_to eq nil
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
      let(:iidxids) { %w(1 1110) }
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
      let(:iidxid) { '0000-0000' }
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
