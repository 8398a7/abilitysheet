# frozen_string_literal: true

feature '推移ログ', type: :system, js: true do
  given(:user) { create(:user, id: 1) }
  context 'ログが存在しない場合' do
    context 'ログイン時' do
      background do
        login(user)
        visit sheet_log_path(user.iidxid)
      end
      scenario 'クリア推移表の文字列が存在する' do
        expect(page).to have_content('クリア推移表')
      end
    end

    context '非ログイン時' do
      background do
        visit sheet_log_path(user.iidxid)
      end
      scenario 'クリア推移表の文字列が存在する' do
        expect(page).to have_content('クリア推移表')
      end
    end
  end

  context 'ログが存在する場合' do
    background do
      create(:sheet, id: 1, title: 'graph', active: true)
      create(:log, sheet_id: 1, user_id: 1, pre_state: 6, new_state: 6)
    end

    context 'ログイン時' do
      background do
        login(user)
        visit sheet_log_path(user.iidxid)
      end
      scenario '推移ページが表示できる' do
        expect(page).to have_content('クリア推移表')
      end
    end

    context '非ログイン時' do
      background do
        visit sheet_log_path(user.iidxid)
      end
      scenario '推移ページが表示できる' do
        expect(page).to have_content('クリア推移表')
      end
    end
  end
end
