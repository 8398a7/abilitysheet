class Sheet < ActiveRecord::Base
  has_many :scores
  has_many :logs
  has_one :ability

  delegate :e,   to: :ability
  delegate :c,   to: :ability
  delegate :h,   to: :ability
  delegate :exh, to: :ability
  delegate :fc,  to: :ability
  delegate :aaa, to: :ability

  scope :active, -> { where(active: true) }

  after_create :create_score_and_ability

  def create_score_and_ability
    SheetWorker.perform_async(id)
  end
end
