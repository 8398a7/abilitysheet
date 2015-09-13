describe Scrape::IIDXME do
  let(:user) { create(:user, id: 1, iidxid: iidxid) }

  context 'real' do
    let(:iidxme) { Scrape::IIDXME.new }
    context '存在するIIDXIDで処理を行う場合' do
      let(:iidxid) { '8594-9652' }
      it '#async' do
        create(:sheet, id: 1, title: 'F')
        create(:score, id: 1, user_id: 1, sheet_id: 1)
        expect(Score.find(1).state).to eq 7
        expect(Score.find(1).score).to eq nil
        expect(Score.find(1).bp).to eq nil
        expect(iidxme.async(user.iidxid)).to be_truthy
        expect(Score.find(1).state).not_to eq 7
        expect(Score.find(1).score).not_to eq nil
        expect(Score.find(1).bp).not_to eq nil
      end
      context 'IIDXIDの書式が正しくない場合' do
        let(:iidxids) { %w(1 1110) }
        it '#async' do
          iidxids.each { |iidxid| expect(iidxme.async(iidxid)).to be_falsy }
        end
      end
      context '存在しないIIDXIDで処理を行う場合' do
        let(:iidxid) { '0000-0000' }
        it '#async' do
          expect(iidxme.async(user.iidxid)).to be_falsy
        end
      end
    end
  end

  context 'mock' do
    let(:iidxme_mock_root) { "#{Rails.root}/spec/mock/iidxme" }
    before { @iidxme = Scrape::IIDXME.new }
    context '存在するIIDXIDで処理を行う場合' do
      let(:iidxid) { '8594-9652' }
      before do
        res = JSON.parse(File.read("#{iidxme_mock_root}/correct"))
        allow(@iidxme).to receive(:data_get).and_return(res)
      end
      it '#async' do
        create(:sheet, id: 1, title: 'F')
        create(:score, id: 1, user_id: 1, sheet_id: 1)
        expect(Score.find(1).state).to eq 7
        expect(Score.find(1).score).to eq nil
        expect(Score.find(1).bp).to eq nil
        expect(@iidxme.async(user.iidxid)).to be_truthy
        expect(Score.find(1).state).to eq 0
        expect(Score.find(1).score).to eq 2994
        expect(Score.find(1).bp).to eq 2
      end
    end
    context 'IIDXIDの書式が正しくない場合' do
      let(:iidxids) { %w(1 1110) }
      before do
        res = JSON.parse(File.read("#{iidxme_mock_root}/correct"))
        allow(@iidxme).to receive(:data_get).and_return(res)
      end
      it '#async' do
        iidxids.each { |iidxid| expect(@iidxme.async(iidxid)).to be_falsy }
      end
    end
    context '存在しないIIDXIDで処理を行う場合' do
      let(:iidxid) { '0000-0000' }
      before do
        res = JSON.parse(File.read("#{iidxme_mock_root}/not_found"))
        allow(@iidxme).to receive(:search_api).and_return(res)
      end
      it '#async' do
        expect(@iidxme.async(user.iidxid)).to be_falsy
      end
      it '#process' do
        expect(@iidxme.send(:process, user.iidxid)).to be_falsy
      end
      it '#user_id_search' do
        expect(@iidxme.send(:user_id_search, user.iidxid)).to be_falsy
      end
      it '#data_get' do
        expect(@iidxme.send(:data_get, user.iidxid)).to be_falsy
      end
    end
  end
end
