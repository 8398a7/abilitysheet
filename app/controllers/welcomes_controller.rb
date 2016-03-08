class WelcomesController < ApplicationController
  def index
    @title = 'TOP'
  end

  # TODO: support 1 year(start: 15/12/20)
  def migrate_domain
    redirect_uri = env['PATH_INFO'].gsub('/abilitysheet', '')
    flash[:alert] = 'URLの/abilitysheetが不要になりました，ブックマーク等は変更下さい'
    redirect_to redirect_uri
  end
end
