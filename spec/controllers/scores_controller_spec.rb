require 'rails_helper'

RSpec.describe ScoresController, type: :request do
  let(:user) { FactoryGirl.create(:user) }
  before { FactoryGirl.create(:sheet) }
  context 'ログイン時' do
    before { login_as(user, scope: :user, run_callbacks: false) }

    context 'GET' do
      it '#attribute' do
        visit scores_path(Sheet.first.id)
        expect(page).to have_content('404')
      end
    end
  end
end

