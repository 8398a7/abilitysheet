# frozen_string_literal: true

class VersionUpJob < ApplicationJob
  queue_as :system

  def perform
    User.version_up!
  end
end
