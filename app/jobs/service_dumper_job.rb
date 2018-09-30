# frozen_string_literal: true

class ServiceDumperJob < ApplicationJob
  queue_as :service_dumper

  def perform
    ServiceDumper.new.dump_and_upload
  end
end
