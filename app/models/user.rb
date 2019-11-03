# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  username               :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  iidxid                 :string           not null
#  version                :integer          default(22), not null
#  djname                 :string           not null
#  grade                  :integer
#  pref                   :integer          not null
#  role                   :integer          default(0), not null
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_iidxid                (iidxid) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :recoverable, :trackable, :validatable, :lockable
  attr_accessor :login
  has_one_attached :avatar

  include User::Api
  include User::DeviseMethods
  include User::FollowMethods
  include User::List
  include User::Role
  include User::Static
  include User::Ist

  has_many :scores, dependent: :delete_all
  has_many :logs, dependent: :delete_all
  has_many :follows, dependent: :delete_all
  has_many :followers, foreign_key: :target_user_id, class_name: 'Follow', dependent: :delete_all
  has_many :follow_users, through: :follows, source: :to_user
  has_many :follower_users, through: :followers, source: :from_user
  has_many :messages, dependent: :delete_all

  validates :email, uniqueness: true, presence: true, format: { with: Devise.email_regexp, message: 'が正しくありません。' }

  validates :iidxid, format: { with: /\A\d{4}-\d{4}\z/, message: 'が正しくありません。' }, length: { is: 9 }, uniqueness: true, presence: true
  validates :grade, numericality: { only_integer: true }, inclusion: { in: Abilitysheet::Application.config.iidx_grade..19, message: 'のパラメタが異常です。' }, presence: true
  validates :pref, numericality: { only_integer: true }, inclusion: { in: 0..47, message: 'のパラメタが異常です。' }, presence: true
  validates :djname, length: { maximum: 6 }, format: { with: /\A[A-Z0-9\-\_.*!#&$]+\z/, message: 'は半角大文字英字で記入して下さい' }, presence: true
  validates :username, length: { maximum: 15 }, format: { with: /\A[a-z_0-9]+\z/, message: 'は半角小文字英数字で記入して下さい' }, uniqueness: true, presence: true

  # iidx_versionが新しくなってから実行する
  def version_up!
    update_column(:grade, GRADE.size - 1)
    current_version = Abilitysheet::Application.config.iidx_version
    return if scores.where(version: current_version).count == scores.where(version: current_version - 1).count

    ApplicationRecord.transaction do
      new_scores = []
      now = Time.now
      scores.select(:sheet_id, :state, :version).where(version: current_version - 1).each do |score|
        new_score = scores.find { |s| s.version == current_version && s.sheet_id == score.sheet_id }
        next if new_score

        new_scores.push(
          state: score.state,
          sheet_id: score.sheet_id,
          user_id: id,
          version: current_version,
          created_at: now,
          updated_at: now
        )

        if (new_scores.count % 1000).zero?
          Score.insert_all!(new_scores)
          new_scores = []
        end
      end
      Score.insert_all!(new_scores) unless new_scores.count.zero?
    end
  end

  def pref_name
    User::Static::PREF[pref]
  end

  class << self
    def dan
      array = []
      Static::GRADE.each.with_index(0) { |d, i| array.push([d, i]) if Abilitysheet::Application.config.iidx_grade <= i }
      array
    end

    def belongs
      array = []
      Static::PREF.each_with_index { |p, i| array.push([p, i]) }
      array
    end

    def version_up!
      users_count = count
      logger.info("start: #{Time.now}, users: #{users_count}")
      completed_count = 0
      all.find_each do |user|
        user.version_up!
        completed_count += 1
        logger.info("completed count: #{completed_count}") if (completed_count % 100).zero?
      end
      logger.info("done: #{Time.now}, users: #{users_count}")
    end
  end
end
