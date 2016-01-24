
module Abilitysheet
  require 'v1/base'
  class API < Grape::API
    logger = Logger.new GrapeLogging::MultiIO.new(STDOUT, File.open('log/grape.log', 'a')), 'daily'
    logger.formatter = GrapeLogging::Formatters::Default.new
    use GrapeLogging::Middleware::RequestLogger, logger: logger

    mount V1::Base
  end
end
