# frozen_string_literal: true

feature '連絡フォーム', type: :system do
  given(:user) { create(:user, id: 1) }
  given(:sheet) { create(:sheet) }
  background do
    create(:score, user_id: user.id, sheet_id: sheet.id)
    visit new_message_path
  end

  describe 'new' do
    context 'ログイン時' do
      background do
        login(user)
        visit new_message_path
      end
      scenario '連絡フォームが正しく表示できる' do
        expect(page).to have_content('連絡フォーム')
      end
    end

    context '非ログイン時' do
      scenario '連絡フォームが正しく表示できる' do
        expect(page).to have_content('連絡フォーム')
      end
    end
  end

  describe 'create' do
    let(:email) { 'message@mail.iidx.app' }
    context 'ログイン時' do
      background do
        login(user)
        visit new_message_path
      end
      scenario 'メッセージが送信できる' do
        allow(Slack::MessageDispatcher).to receive(:send).and_return(true)
        body = 'create-message-test-with-sign-in'
        fill_in 'message_email', with: email
        fill_in 'message_body', with: body
        click_button '送信'
        message = Message.find_by(body: body)
        expect(message.email).to eq email
        expect(message.user_id).to eq user.id
        expect(message.state).to be_falsey
      end
    end

    context '非ログイン時' do
      scenario 'メッセージが送信できる' do
        allow(Slack::MessageDispatcher).to receive(:send).and_return(true)
        body = 'create-message-test'
        fill_in 'message_email', with: email
        fill_in 'message_body', with: body
        click_button '送信'
        message = Message.find_by(body: body)
        expect(message.email).to eq email
        expect(message.user_id).to eq nil
        expect(message.state).to be_falsey
      end
    end
  end
end
