# frozen_string_literal: true

feature '管理用メッセージページ', type: :system do
  describe '#index' do
    context '管理者でない' do
      let(:role) { User::Role::ADMIN - 1 }
      scenario 'トップページにリダイレクトされる' do
        user = create(:user)
        login(user)
        visit admin_messages_path
        expect(page.current_path).to eq '/'
      end
    end

    context '管理者' do
      let(:role) { User::Role::ADMIN }
      scenario '表示できる' do
        user = create(:user)
        user.add_role(:admin)
        login(user)
        visit admin_messages_path
        expect(page.current_path).to eq '/admin/messages'
      end
    end
  end

  describe '#active' do
    let!(:message) { create(:message, user_id: 1) }
    background do
      user = create(:user, id: 1)
      user.add_role(:admin)
      login(user)
      visit admin_messages_path
    end
    context '管理者' do
      it 'stateが変わっている' do
        expect(message.state).to be_falsey
        click_on '未読'
        expect(message.reload.state).to be_truthy
      end
    end
  end

  describe '#inactive' do
    let!(:message) { create(:message, state: true, user_id: 1) }
    background do
      user = create(:user, id: 1)
      user.add_role(:admin)
      login(user)
      visit admin_messages_path
    end
    context '管理者' do
      it 'stateが変わっている' do
        expect(message.state).to be_truthy
        click_on '既読'
        expect(message.reload.state).to be_falsey
      end
    end
  end
end
