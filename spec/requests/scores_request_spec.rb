require 'rails_helper'

RSpec.describe ScoresController, type: :request do
  let(:user) { create(:user) }
  before { create(:sheet) }
  context 'ログイン時' do
    before { login_as(user, scope: :user, run_callbacks: false) }

    context 'GET' do
      it '#attribute' do
        visit edit_score_path(Sheet.first.id)
        expect(page).to have_content('404')
      end
    end
  end
end
