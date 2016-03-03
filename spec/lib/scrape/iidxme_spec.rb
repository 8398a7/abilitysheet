describe Scrape::IIDXME do
  let(:user) { create(:user, id: 1, iidxid: iidxid) }

  context 'real' do
    let(:iidxme) { Scrape::IIDXME.new }
    context '存在するIIDXIDで処理を行う場合' do
      let(:iidxid) { '8594-9652' }
      it '#async' do
        create(:sheet, id: 1, title: 'F')
        create(:score, id: 1, user_id: 1, sheet_id: 1)
        user.update!(grade: 2)
        expect(Score.find(1).state).to eq 7
        expect(Score.find(1).score).to eq nil
        expect(Score.find(1).bp).to eq nil
        expect(User.find(1).grade).to eq 2
        expect(iidxme.async(user.iidxid)).to be_truthy
        expect(Score.find(1).state).not_to eq 7
        expect(Score.find(1).score).not_to eq nil
        expect(Score.find(1).bp).not_to eq nil
        expect(User.find(1).grade).to eq 0
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
        res = JSON.parse(File.read("#{iidxme_mock_root}/correct.json"))
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
    context '不要なログが作成されない' do
      let(:iidxid) { '8594-9652' }
      before do
        res = JSON.parse(File.read("#{iidxme_mock_root}/correct.json"))
        allow(@iidxme).to receive(:data_get).and_return(res)
        user
        sync_sheet
        JSON.parse(File.read("#{iidxme_mock_root}/score.json")).each do |s|
          create(:score, user_id: user.id, sheet_id: s['sheet_id']).update_with_logs(s)
        end
      end
      it 'Score#update_with_logs' do
        count = 0
        Log.all.each { |l| count += 1 if l.pre_state == l.new_state && l.pre_score == l.new_score && l.pre_bp == l.new_bp }
        expect(count).to eq 0
      end
    end

    context 'IIDXIDの書式が正しくない場合' do
      let(:iidxids) { %w(1 1110) }
      before do
        res = JSON.parse(File.read("#{iidxme_mock_root}/correct.json"))
        allow(@iidxme).to receive(:data_get).and_return(res)
      end
      it '#async' do
        iidxids.each { |iidxid| expect(@iidxme.async(iidxid)).to be_falsy }
      end
    end
    context '存在しないIIDXIDで処理を行う場合' do
      let(:iidxid) { '0000-0000' }
      before do
        res = JSON.parse(File.read("#{iidxme_mock_root}/userlist.json"), symbolize_names: true)
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
