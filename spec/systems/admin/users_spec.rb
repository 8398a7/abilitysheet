# frozen_string_literal: true

feature '管理用メッセージページ', type: :system do
  background do
    user = create(:user, id: 1, role: role)
    login(User.find(user.id))
    visit admin_users_path
  end

  describe '#index' do
    context '管理者でない' do
      let(:role) { User::Role::ADMIN - 1 }
      scenario 'トップページにリダイレクトされる' do
        expect(page.current_path).to eq '/'
      end
    end

    context '管理者' do
      let(:role) { User::Role::ADMIN }
      scenario '表示できる' do
        expect(page.current_path).to eq '/admin/users'
      end
    end
  end

  describe '#lock', js: true do
    let!(:user2) { create(:user, id: 3, iidxid: '4847-4938', username: 'delete') }
    background do
      visit admin_users_path
    end
    context '管理者' do
      let(:role) { User::Role::ADMIN }
      it 'ロックできる' do
        expect(user2.access_locked?).to be_falsey
        click_on '無効化', match: :first
        expect(page).to have_content '有効化'
        expect(user2.reload.access_locked?).to be_truthy
      end
    end
  end

  describe '#unlock', js: true do
    let!(:user2) { create(:user, id: 3, iidxid: '4847-4938', username: 'delete') }
    background do
      user2.lock_access!
      visit admin_users_path
    end
    context '管理者' do
      let(:role) { User::Role::ADMIN }
      it 'アンロックできる' do
        expect(user2.access_locked?).to be_truthy
        click_on '有効化', match: :first
        expect(page).to have_content '無効化'
        expect(user2.reload.access_locked?).to be_falsey
      end
    end
  end
end
