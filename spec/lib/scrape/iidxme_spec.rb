# frozen_string_literal: true

describe Scrape::IIDXME do
  let(:user) { create(:user, id: 1, djname: 'TEST', grade: 0, iidxid: iidxid) }

  context 'real' do
    let(:iidxme) { Scrape::IIDXME.new }
    context '存在するIIDXIDで処理を行う場合' do
      let(:iidxid) { '8594-9652' }
      it '#sync' do
        create(:sheet, id: 1, title: 'AA')
        create(:score, id: 1, user_id: 1, sheet_id: 1)
        expect(Score.find(1).state).to eq 7
        expect(Score.find(1).score).to eq nil
        expect(Score.find(1).bp).to eq nil
        expect(user.grade).to eq 0
        expect(user.djname).to eq 'TEST'
        expect(iidxme.sync(user.iidxid)).to be_truthy
        expect(Score.find(1).state).not_to eq 7
        expect(Score.find(1).score).not_to eq nil
        expect(Score.find(1).bp).not_to eq nil
        user.reload
        expect(user.grade).to eq 4
        expect(user.djname).to eq '839'
        expect(user.avatar.attached?).to eq true
      end
      context 'IIDXIDの書式が正しくない場合' do
        let(:iidxids) { %w[1 1110] }
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
    before { @iidxme = Scrape::IIDXME.new }
    context '存在するIIDXIDで処理を行う場合' do
      let(:iidxid) { '8594-9652' }
      it '#sync' do
        create(:sheet, id: 1, title: 'AA')
        create(:score, id: 1, user_id: 1, sheet_id: 1)
        expect(Score.find(1).state).to eq 7
        expect(Score.find(1).score).to eq nil
        expect(Score.find(1).bp).to eq nil
        VCR.use_cassette 'lib/scrape/iidxme/sync' do
          expect(@iidxme.sync(user.iidxid)).to be_truthy
        end
        expect(Score.find(1).state).to eq 0
        expect(Score.find(1).score).to eq 3105
        expect(Score.find(1).bp).to eq 2
        expect(user.avatar.attached?).to eq true
      end

      it 'sphがある譜面が正しく登録される' do
        VCR.use_cassette('sync_sheet') do
          RedisHelper.load_sheets_data
          sync_sheet
        end
        VCR.use_cassette('lib/scrape/iidxme/sync') { @iidxme.sync(user.iidxid) }
        titles = ['gigadelic[H]', 'gigadelic[A]', 'Innocent Walls[H]', 'Innocent Walls[A]']
        sheet_ids = Sheet.where(title: titles).pluck(:id)
        scores = user.scores.where(sheet_id: sheet_ids)
        expect(scores.count).to eq 4
      end
    end
    context '不要なログが作成されない' do
      let(:iidxid) { '8594-9652' }
      it 'Score#update_with_logs' do
        VCR.use_cassette('lib/scrape/iidxme/sync') { @iidxme.sync(user.iidxid) }
        count = 0
        Log.all.each { |l| count += 1 if l.pre_state == l.new_state && l.pre_score == l.new_score && l.pre_bp == l.new_bp }
        expect(count).to eq 0
      end
    end

    context 'IIDXIDの書式が正しくない場合' do
      let(:iidxids) { %w[1 1110] }
      it '#sync' do
        VCR.use_cassette 'lib/scrape/iidxme/sync' do
          iidxids.each { |iidxid| expect(@iidxme.sync(iidxid)).to be_falsy }
        end
      end
    end
    context '存在しないIIDXIDで処理を行う場合' do
      let(:iidxid) { '0000-0000' }
      it '#sync' do
        VCR.use_cassette 'lib/scrape/iidxme/sync' do
          expect(@iidxme.sync(user.iidxid)).to be_falsy
        end
      end
      it '#process' do
        VCR.use_cassette 'lib/scrape/iidxme/sync' do
          expect(@iidxme.send(:process, user.iidxid)).to be_falsy
        end
      end
      it '#user_id_search' do
        VCR.use_cassette 'lib/scrape/iidxme/sync' do
          expect(@iidxme.send(:user_id_search, user.iidxid)).to be_falsy
        end
      end
      it '#get_data' do
        VCR.use_cassette 'lib/scrape/iidxme/sync' do
          expect(@iidxme.send(:get_data, user.iidxid)).to be_falsy
        end
      end
    end
  end
end
