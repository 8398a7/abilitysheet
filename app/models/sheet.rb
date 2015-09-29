# == Schema Information
#
# Table name: sheets
#
#  id         :integer          not null, primary key
#  title      :string
#  n_ability  :integer
#  h_ability  :integer
#  version    :integer
#  active     :boolean          default(TRUE), not null
#  textage    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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

  def self.sync_created_at
    version = {
      5 => '2001/3/27',
      6 => '2001/9/28',
      7 => '2002/3/27',
      8 => '2002/9/27',
      9 => '2003/6/25',
      10 => '2004/2/18',
      11 => '2004/10/28',
      12 => '2005/7/13',
      13 => '2006/3/15',
      14 => '2007/2/21',
      15 => '2007/12/19',
      16 => '2008/11/19',
      17 => '2009/10/21',
      18 => '2010/9/15',
      19 => '2011/9/15',
      20 => '2012/9/19',
      21 => '2013/11/13',
      22 => '2014/9/17'
    }
    Sheet.all.each do |s|
      s.update(created_at: version[s.version])
    end
  end
end
