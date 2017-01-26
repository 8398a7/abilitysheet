# frozen_string_literal: true
describe Scrape::IIDXME do
  let(:user) { create(:user, id: 1, djname: 'TEST', grade: 4, iidxid: iidxid) }

  context 'real' do
    let(:iidxme) { Scrape::IIDXME.new }
    context '存在するIIDXIDで処理を行う場合' do
      let(:iidxid) { '8594-9652' }
      it '#sync' do
        create(:sheet, id: 1, title: 'F')
        create(:score, id: 1, user_id: 1, sheet_id: 1)
        expect(Score.find(1).state).to eq 7
        expect(Score.find(1).score).to eq nil
        expect(Score.find(1).bp).to eq nil
        expect(user.grade).to eq 4
        expect(user.djname).to eq 'TEST'
        expect(iidxme.sync(user.iidxid)).to be_truthy
        expect(Score.find(1).state).not_to eq 7
        expect(Score.find(1).score).not_to eq nil
        expect(Score.find(1).bp).not_to eq nil
        user.reload
        expect(user.grade).to eq 0
        expect(user.djname).to eq 'HUSL1L'
      end
      context 'IIDXIDの書式が正しくない場合' do
        let(:iidxids) { %w(1 1110) }
        it '#sync' do
          iidxids.each { |iidxid| expect(iidxme.sync(iidxid)).to be_falsy }
        end
      end
      context '存在しないIIDXIDで処理を行う場合' do
        let(:iidxid) { '0000-0000' }
        it '#sync' do
          expect(iidxme.sync(user.iidxid)).to be_falsy
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
        allow(@iidxme).to receive(:get_data).and_return(res)
      end
      it '#sync' do
        create(:sheet, id: 1, title: 'F')
        create(:score, id: 1, user_id: 1, sheet_id: 1)
        expect(Score.find(1).state).to eq 7
        expect(Score.find(1).score).to eq nil
        expect(Score.find(1).bp).to eq nil
        expect(@iidxme.sync(user.iidxid)).to be_truthy
        expect(Score.find(1).state).to eq 0
        expect(Score.find(1).score).to eq 2994
        expect(Score.find(1).bp).to eq 2
      end
    end
    context '不要なログが作成されない' do
      let(:iidxid) { '8594-9652' }
      before do
        res = JSON.parse(File.read("#{iidxme_mock_root}/correct.json"))
        allow(@iidxme).to receive(:get_data).and_return(res)
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
        allow(@iidxme).to receive(:get_data).and_return(res)
      end
      it '#sync' do
        iidxids.each { |iidxid| expect(@iidxme.sync(iidxid)).to be_falsy }
      end
    end
    context '存在しないIIDXIDで処理を行う場合' do
      let(:iidxid) { '0000-0000' }
      before do
        res = JSON.parse(File.read("#{iidxme_mock_root}/userlist.json"), symbolize_names: true)
        allow(@iidxme).to receive(:search_api).and_return(res)
      end
      it '#sync' do
        expect(@iidxme.sync(user.iidxid)).to be_falsy
      end
      it '#process' do
        expect(@iidxme.send(:process, user.iidxid)).to be_falsy
      end
      it '#user_id_search' do
        expect(@iidxme.send(:user_id_search, user.iidxid)).to be_falsy
      end
      it '#get_data' do
        expect(@iidxme.send(:get_data, user.iidxid)).to be_falsy
      end
    end
  end
end
