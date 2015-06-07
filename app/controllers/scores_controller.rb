class ScoresController < ApplicationController
  before_action :authenticate_user!
  before_action :version_confirm

  def attribute
    render file: Rails.root.join('public', '404.html'), status: 404, layout: true, content_type: 'text/html' and return if request.get?
    sheet = Sheet.find_by(id: params[:id])
    @title = sheet.title
    @textage = sheet.textage
    if User.find_by(id: current_user.id).scores.exists?(sheet_id: params[:id], version: @version)
      @score = User.find_by(id: current_user.id).scores.find_by(sheet_id: params[:id], version: @version)
    else
      @score = Score.new
    end
    render :show_modal
  end

  def update
    Score.update(
      current_user.id,
      params[:score][:sheet_id].to_i,
      params[:score][:state].to_i
    )
    render :reload
  end

  private

  def version_confirm
    @version = Abilitysheet::Application.config.iidx_version
  end
end
