# frozen_string_literal: true

module ResponsiveHelper
  def resize_window_to_iphone6
    Capybara.current_session.driver.headers = { 'User-Agent' => 'iPhone' }
    resize_window_by([667, 375])
  end

  def resize_window_default
    Capybara.current_session.driver.headers = {}
    resize_window_by([1024, 768])
  end

  private

  def resize_window_by(size)
    Capybara.current_session.driver.resize_window(size[0], size[1])
  end
end
