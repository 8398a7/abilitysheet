class Admin::SheetsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user!
  before_action :load_sheet, except: [:index, :new, :create]

  def index
    @search = Sheet.search(params[:q])
    @sheets = @search.result
  end

  def new
    render :show_modal_form
  end

  def create
    @sheet = Sheet.create(sheet_params)
    render :reload
  end

  def show
  end

  def edit
    render :show_modal_form
  end

  def update
    @sheet.update(sheet_params)
    render :reload
  end

  def destroy
    @sheet.destroy
    render :reload
  end

  def inactive
    @sheet.update(active: false)
    render :reload
  end

  def active
    @sheet.update(active: true)
    render :reload
  end

  private

  def sheet_params
    params.require(:sheet).permit(
      :title, :n_ability, :h_ability, :version
    )
  end

  def load_sheet
    return unless params[:id]
    @sheet = Sheet.find_by(id: params[:id])
  end
end
