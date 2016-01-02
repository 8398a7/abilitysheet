feature 'グラフログ', js: true do
  given(:user) { create(:user, id: 1) }
  context 'ログが存在しない場合' do
    context 'ログイン時' do
      background do
        login(user)
        visit graph_log_path(user.iidxid)
        wait_for_ajax
      end
      scenario 'ログ一覧ページに遷移する' do
        expect(page).to have_no_content('月別更新数')
        expect(page).to have_content('更新履歴')
      end
    end

    context '非ログイン時' do
      background do
        visit graph_log_path(user.iidxid)
        wait_for_ajax
      end
      scenario 'ログ一覧ページに遷移する' do
        expect(page).to have_no_content('月別更新数')
        expect(page).to have_content('更新履歴')
      end
    end
  end

  context 'ログが存在する場合' do
    background do
      create(:sheet, id: 1, title: 'graph')
      create(:log, sheet_id: 1, user_id: 1)
    end

    context 'ログイン時' do
      background do
        login(user)
        visit graph_log_path(user.iidxid)
        wait_for_ajax
      end
      scenario 'グラフページが表示できる' do
        expect(page).to have_content('月別更新数')
        expect(page).to have_no_content('更新履歴')
      end
    end

    context '非ログイン時' do
      background do
        visit graph_log_path(user.iidxid)
        wait_for_ajax
      end
      scenario 'グラフページが表示できる' do
        expect(page).to have_content('月別更新数')
        expect(page).to have_no_content('更新履歴')
      end
    end
  end
end
