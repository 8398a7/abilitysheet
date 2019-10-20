# frozen_string_literal: true

feature 'sign up', type: :system do
  background do
    visit new_user_registration_path
    sync_sheet
    allow(Slack::UserDispatcher).to receive(:new_register_notify).and_return(true)
  end
  def input_sign_up_form(iidxid)
    fill_in 'user_email', with: 'sign_up_spec@mail.iidx.app'
    fill_in 'user_username', with: 'signup'
    fill_in 'user_djname', with: 'SIGNUP'
    fill_in 'user_iidxid', with: iidxid
    fill_in 'user_password', with: 'hogehoge'
    fill_in 'user_password_confirmation', with: 'hogehoge'
    select '京都府', from: 'user_pref'
    select '八段', from: 'user_grade'
    click_button '登録'
  end

  scenario 'ISTに存在しないユーザの場合でも登録できる' do
    expect(User.exists?(email: 'sign_up_spec@mail.iidx.app')).to be_falsey
    expect do
      perform_enqueued_jobs do
        VCR.use_cassette('not_found_ist') do
          input_sign_up_form('1234-5678')
        end
      end
    end.to change { User.count }.by(1)
    expect(User.exists?(email: 'sign_up_spec@mail.iidx.app')).to be_truthy
  end
  scenario 'ISTに存在するユーザなら同期して登録できる' do
    expect(User.exists?(email: 'sign_up_spec@mail.iidx.app')).to be_falsey
    iidxid = '8594-9652'
    expect do
      perform_enqueued_jobs do
        VCR.use_cassette('ist') do
          input_sign_up_form(iidxid)
        end
      end
    end.to change { User.count }.by(1)
    user = User.find_by(iidxid: iidxid)
    expect(user.present?).to be_truthy
    expect(user.scores.is_current_version.find_by(sheet: Sheet.find_by!(title: 'AA')).score).to eq 3045
  end
end
