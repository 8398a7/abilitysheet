# frozen_string_literal: true

feature '新規登録の受付終了', type: :system do
  scenario '以前の新規登録ページからデラレコを案内する' do
    visit new_user_registration_path

    expect(page).to have_content('新規登録の受付は終了しました。')
    expect(page).to have_link('デラレコで新規登録', href: 'https://record.iidx.app/')
    expect(page).to have_link('ログイン', href: new_user_session_path)
    expect(page).to have_no_selector('form[action="/users"]')
    expect(page).to have_no_field('user_password')
  end

  scenario 'ログインページから新規利用者をデラレコに案内する' do
    visit new_user_session_path

    expect(page).to have_link('デラレコで新規登録', href: 'https://record.iidx.app/')
    expect(page).to have_no_link(href: new_user_registration_path)
    expect(page).to have_field('user_login')
    expect(page).to have_link('再発行', href: new_user_password_path)
  end

  scenario 'パスワード再発行ページから新規利用者をデラレコに案内する' do
    visit new_user_password_path

    expect(page).to have_link('デラレコで新規登録', href: 'https://record.iidx.app/')
    expect(page).to have_no_link(href: new_user_registration_path)
    expect(page).to have_field('user_email')
  end

  scenario 'OAuth連携のヘルプからデラレコを案内する' do
    visit oauth_helps_path

    expect(page).to have_link(href: 'https://record.iidx.app/')
    expect(page).to have_no_link(href: new_user_registration_path)
    expect(page).to have_link('ユーザ編集ページ', href: edit_user_registration_path)
  end
end
