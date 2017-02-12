# frozen_string_literal: true

class StringFileIO < StringIO
  def self.create_from_canvas_base64(str)
    return nil if str.nil?

    head, data = str.split ',', 2

    return nil if data.nil?

    _, mime_type = head.split(/:|;/)

    bin = Base64.decode64 data

    new bin, mime_type
  end

  def initialize(blob, content_type)
    super(blob)
    @content_type = content_type
    self
  end

  def original_filename
    'image'
  end

  attr_reader :content_type
end
