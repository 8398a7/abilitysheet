class Sheet < ActiveRecord::Base
  has_many :scores
  has_many :logs
  has_one :static

  delegate :e,   to: :static
  delegate :c,   to: :static
  delegate :h,   to: :static
  delegate :exh, to: :static
  delegate :fc,  to: :static
  delegate :aaa, to: :static

  scope :active, -> { where(active: true) }

  after_create :create_score_and_static

  def create_score_and_static
    SheetWorker.perform_async(id)
  end
end
