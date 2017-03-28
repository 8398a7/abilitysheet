# frozen_string_literal: true

describe Api::V1::UsersController, type: :request do
  include_context 'api'
  before { allow(SidekiqDispatcher).to receive(:exists?).and_return(true) }

  describe 'PUT /api/v1/users/change_rival/:iidxid' do
    before do
      @user = create(:user)
      @user2 = create(:user, username: 'user2', iidxid: '1111-1111')
    end
    describe 'ライバル情報を変更できる' do
      let(:url) { "/api/v1/users/change_rival/#{@user2.iidxid}" }
      let(:method) { 'put' }
      context 'ログインしていない場合' do
        it_behaves_like '401 Unauthorized'
      end

      context 'ログインしている場合' do
        before { login(@user) }
        context 'ライバルに追加する場合' do
          let(:result) do
            {
              current_user: {
                id: Integer,
                iidxid: String,
                djname: String,
                role: Integer,
                grade: Integer,
                pref: Integer,
                created_at: String,
                follows: [@user2.iidxid],
                followers: [],
                image_url: nil
              },
              target_user: {
                id: Integer,
                iidxid: String,
                djname: String,
                role: Integer,
                grade: Integer,
                pref: Integer,
                created_at: String,
                follows: [],
                followers: [@user.iidxid],
                image_url: nil
              }
            }
          end
          it_behaves_like '200 Success'
        end
        context 'ライバルから削除する場合' do
          before { @user.follow(@user2.iidxid) }
          let(:result) do
            {
              current_user: {
                id: Integer,
                iidxid: String,
                djname: String,
                role: Integer,
                grade: Integer,
                pref: Integer,
                created_at: String,
                follows: [],
                followers: [],
                image_url: nil
              },
              target_user: {
                id: Integer,
                iidxid: String,
                djname: String,
                role: Integer,
                grade: Integer,
                pref: Integer,
                created_at: String,
                follows: [],
                followers: [],
                image_url: nil
              }
            }
          end
          it_behaves_like '200 Success'
        end
      end
    end
  end

  describe 'GET /api/v1/users/me' do
    before { create(:user) }
    describe 'ユーザのログイン状態を返す' do
      let(:url) { '/api/v1/users/me' }
      let(:method) { 'get' }
      context 'ログインしていない場合' do
        let(:result) do
          { current_user: nil }
        end
        it_behaves_like '200 Success'
      end

      context 'ログインしている場合' do
        before { login(User.first) }
        let(:result) do
          {
            current_user: {
              id: Integer,
              iidxid: String,
              djname: String,
              role: Integer,
              follows: Array,
              grade: Integer,
              pref: Integer,
              created_at: String,
              followers: Array,
              image_url: nil
            }
          }
        end
        it_behaves_like '200 Success'
      end
    end
  end

  describe 'GET /api/v1/users/status' do
    before { create(:user) }
    describe 'ユーザのログイン状態を返す' do
      let(:url) { '/api/v1/users/status' }
      let(:method) { 'get' }
      context 'ログインしていない場合' do
        let(:result) do
          { status: nil }
        end
        it_behaves_like '200 Success'
      end

      context 'ログインしている場合' do
        before { login(User.first) }
        let(:result) do
          { status: User.first.iidxid }
        end
        it_behaves_like '200 Success'
      end
    end
  end

  describe 'POST /api/v1/users/score_viewer' do
    SHEET_NUM = 2
    let(:user) { create(:user, id: 1) }
    let(:url) { '/api/v1/users/score_viewer' }
    let(:method) { 'post' }
    context 'ログインしている' do
      before { login(user) }
      context 'データが正常な場合' do
        before do
          (1..SHEET_NUM).each do |sheet_id|
            create(:sheet, id: sheet_id)
            expect(Score.exists?(sheet_id: sheet_id, user_id: 1)).to eq false
          end
        end
        let(:parameters) do
          {
            'id' => user.iidxid,
            'state' => '[{"id":"1","cl":1,"pg":1158,"g":373,"miss":6},{"id":"2","cl":6,"pg":1362,"g":584,"miss":83}]'
          }
        end
        let(:result) do
          { status: 'ok' }
        end
        it_behaves_like '202 Accepted'
        it 'クリアランプが反映されている' do
          post(url, parameters, rack_env)
          elems = JSON.parse(parameters['state'])
          (1..SHEET_NUM).each do |sheet_id|
            expect(Score.find_by(sheet_id: sheet_id, user_id: 1).state).to eq elems[sheet_id - 1]['cl']
          end
        end
        it 'スコアが反映されている' do
          post(url, parameters, rack_env)
          elems = JSON.parse(parameters['state'])
          (1..SHEET_NUM).each do |sheet_id|
            expect(Score.find_by(sheet_id: sheet_id, user_id: 1).score).to eq elems[sheet_id - 1]['pg'] * 2 + elems[sheet_id - 1]['g']
          end
        end
        it 'BPが反映されている' do
          post(url, parameters, rack_env)
          elems = JSON.parse(parameters['state'])
          (1..SHEET_NUM).each do |sheet_id|
            expect(Score.find_by(sheet_id: sheet_id, user_id: 1).bp).to eq elems[sheet_id - 1]['miss']
          end
        end
        it 'ログが反映されている' do
          (1..SHEET_NUM).each do |sheet_id|
            expect(Log.exists?(sheet_id: sheet_id, user_id: 1, created_date: Date.today)).to eq false
          end
          post(url, parameters, rack_env)
          elems = JSON.parse(parameters['state'])
          (1..SHEET_NUM).each do |sheet_id|
            log = Log.find_by(sheet_id: sheet_id, user_id: 1, created_date: Date.today)
            expect(log.pre_bp).to eq nil
            expect(log.pre_score).to eq nil
            expect(log.pre_state).to eq 7
            expect(log.new_bp).to eq elems[sheet_id - 1]['miss']
            expect(log.new_score).to eq elems[sheet_id - 1]['pg'] * 2 + elems[sheet_id - 1]['g']
            expect(log.new_state).to eq elems[sheet_id - 1]['cl']
          end
        end
      end
      context 'スコアが理論値の場合' do
        before do
          create(:sheet, id: 1)
          expect(Score.exists?(sheet_id: 1, user_id: 1)).to eq false
        end
        let(:parameters) do
          {
            'id' => user.iidxid,
            'state' => '[{"id":"1","cl":0,"pg":100,"g":-1,"miss":0}]'
          }
        end
        let(:result) do
          { status: 'ok' }
        end
        it_behaves_like '202 Accepted'
        it 'BPは反映されている' do
          post(url, parameters, rack_env)
          elems = JSON.parse(parameters['state'])
          expect(Score.find_by(sheet_id: 1, user_id: 1).bp).to eq elems[0]['miss']
        end
        it 'スコアは反映されている' do
          post(url, parameters, rack_env)
          elems = JSON.parse(parameters['state'])
          expect(Score.find_by(sheet_id: 1, user_id: 1).score).to eq elems[0]['pg'] * 2
        end
        it 'クリアランプは反映されている' do
          post(url, parameters, rack_env)
          elems = JSON.parse(parameters['state'])
          expect(Score.find_by(sheet_id: 1, user_id: 1).state).to eq elems[0]['cl']
        end
      end
      context 'クリアランプだけ存在する場合' do
        before do
          create(:sheet, id: 1)
          expect(Score.exists?(sheet_id: 1, user_id: 1)).to eq false
        end
        let(:parameters) do
          {
            'id' => user.iidxid,
            'state' => '[{"id":"1","cl":1,"pg":-1,"g":-1,"miss":-1}]'
          }
        end
        let(:result) do
          { status: 'ok' }
        end
        it_behaves_like '202 Accepted'
        it 'BPはnilのままである' do
          post(url, parameters, rack_env)
          expect(Score.find_by(sheet_id: 1, user_id: 1).bp).to eq nil
        end
        it 'スコアはnilのままである' do
          post(url, parameters, rack_env)
          expect(Score.find_by(sheet_id: 1, user_id: 1).score).to eq nil
        end
        it 'クリアランプは反映されている' do
          post(url, parameters, rack_env)
          elems = JSON.parse(parameters['state'])
          expect(Score.find_by(sheet_id: 1, user_id: 1).state).to eq elems[0]['cl']
        end
      end
      context 'ハード落ちなどでBPがない場合' do
        before do
          create(:sheet, id: 1)
          expect(Score.exists?(sheet_id: 1, user_id: 1)).to eq false
        end
        let(:parameters) do
          {
            'id' => user.iidxid,
            'state' => '[{"id":"1","cl":1,"pg":1158,"g":373,"miss":-1}]'
          }
        end
        let(:result) do
          { status: 'ok' }
        end
        it_behaves_like '202 Accepted'
        it 'BPはnilのままである' do
          post(url, parameters, rack_env)
          expect(Score.find_by(sheet_id: 1, user_id: 1).bp).to eq nil
        end
        it 'スコアは反映されている' do
          post(url, parameters, rack_env)
          elems = JSON.parse(parameters['state'])
          expect(Score.find_by(sheet_id: 1, user_id: 1).score).to eq elems[0]['pg'] * 2 + elems[0]['g']
        end
        it 'クリアランプは反映されている' do
          post(url, parameters, rack_env)
          elems = JSON.parse(parameters['state'])
          expect(Score.find_by(sheet_id: 1, user_id: 1).state).to eq elems[0]['cl']
        end
      end
      context 'データが不正な場合' do
        before { login(user) }
        context 'iidxidが現在登録されているユーザと違う場合' do
          let(:parameters) do
            {
              'id' => '0000-0000',
              'state' => '[{"id":"1","cl":1,"pg":1158,"g":373,"miss":6},{"id":"2","cl":6,"pg":1362,"g":584,"miss":83}]'
            }
          end
          it_behaves_like '403 Forbidden'
        end
        context 'paramsに楽曲情報が存在していない場合' do
          before { login(user) }
          let(:parameters) do
            {
              'id' => user.iidxid
            }
          end
          it_behaves_like '400 Bad Request'
        end
        context 'paramsにユーザ情報が存在していない場合' do
          before { login(user) }
          let(:parameters) do
            {
              'state' => '[{"id":"1","cl":1,"pg":1158,"g":373,"miss":6},{"id":"3","cl":6,"pg":1362,"g":584,"miss":83}]'
            }
          end
          it_behaves_like '403 Forbidden'
        end
        context '楽曲情報が存在していない場合' do
          let(:parameters) do
            {
              'id' => user.iidxid,
              'state' => '[{"id":"1","cl":1,"pg":1158,"g":373,"miss":6},{"id":"3","cl":6,"pg":1362,"g":584,"miss":83}]'
            }
          end
          it_behaves_like '404 Not Found'
        end
        context 'パラメータの一部に不足がある場合' do
          let(:parameters) do
            {
              'id' => user.iidxid,
              'state' => '[{"id":"1","cl":1,"pg":1158,"g":373}]'
            }
          end
          it_behaves_like '400 Bad Request'
        end
        context 'パラメータに余分なモノがある場合' do
          let(:parameters) do
            {
              'id' => user.iidxid,
              'state' => '[{"id":"1","cl":1,"pg":1158,"g":373, "miss": 10, "hoge": 10}]'
            }
          end
          it_behaves_like '400 Bad Request'
        end
      end
    end
    context 'ログインしていない' do
      let(:parameters) do
        {
          'id' => '0000-0000',
          'state' => '[{"id":"1","cl":1,"pg":1158,"g":373,"miss":6},{"id":"2","cl":6,"pg":1362,"g":584,"miss":83}'
        }
      end
      it_behaves_like '401 Unauthorized'
    end
  end
end
