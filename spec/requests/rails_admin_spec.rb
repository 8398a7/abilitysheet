require 'rails_helper'

RSpec.describe RailsAdmin, type: :request do
  let(:user) { create(:user, id: 1) }
  before { login_as(user, scope: :user, run_callbacks: false) }

  context '管理者の場合' do
    before do
      user.update(role: 100)
      visit rails_admin_path
    end

    it '管理者ページが閲覧できる' do
      expect(page).to have_content('サイト管理')
    end
  end
end
