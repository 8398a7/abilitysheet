feature 'ライバル情報' do
  given(:user) { create(:user, id: 1) }
  background do
    user2 = create(:user, id: 2, djname: 'RIVALU', iidxid: '1111-1111', username: 'rival')
    user.add_rival(user2.iidxid)
    login(user)
  end

  scenario 'ライバルリストページにライバル相手が存在し，詳細ページに遷移できる' do
    visit list_rival_path
    expect(page).to have_content('RIVALU')
    click_link 'ライバル比較'
    expect(page).to have_title('vs RIVALU')
  end
end
