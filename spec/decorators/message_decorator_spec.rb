# frozen_string_literal: true
describe MessageDecorator do
  before { create(:user, id: 1) }

  describe '#user_name' do
    context 'user_idが指定されていない' do
      it '匿名と表示' do
        message = build_stubbed(:message).decorate
        expect(message.user_name).to eq '匿名'
      end
    end
    context 'user_idが指定されている' do
      it 'djname[iidxid]の書式で表示' do
        message = build_stubbed(:message, user_id: 1).decorate
        expect(message.user_name).to eq 'TEST[1234-5678]'
      end
    end
  end

  describe '#status' do
    context '未チェック' do
      it '未読を表示' do
        message = build_stubbed(:message, state: false).decorate
        expect(message.status).to eq '未読'
      end
    end
    context 'チェック済' do
      it '既読を表示' do
        message = build_stubbed(:message, state: true).decorate
        expect(message.status).to eq '既読'
      end
    end
  end

  describe '#created_at' do
    context '作成日がnilの場合' do
      it '現在日時を整形して表示' do
        message = build_stubbed(:message, created_at: nil).decorate
        expect(message.created_at).to eq DateTime.now.strftime('%Y/%m/%d %H:%M')
      end
    end

    context '作成日が存在する場合' do
      it '存在する日を整形して表示' do
        message = build_stubbed(:message, created_at: '2011-02-22 22:22').decorate
        expect(message.created_at).to eq '2011/02/22 22:22'
      end
    end
  end
end
