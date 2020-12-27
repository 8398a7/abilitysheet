# frozen_string_literal: true

class RailsLogSilencer
  def initialize(app, paths)
    @app = app
    @paths = paths
  end

  def call(env)
    if @paths.include?(env['PATH_INFO'])
      ::Rails.logger.silence { @app.call(env) }
    else
      @app.call(env)
    end
  end
end
