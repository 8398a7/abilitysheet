# frozen_string_literal: true

class HelpsController < ApplicationController
  def official
    domain = Rails.env.development? ? request.host_with_port : request.host
    @bookmarklet = %(javascript:void(function(){var d=document;var s=d.createElement("script");s.id="abilitysheet";s.type="text/javascript";s.src="#{request.scheme}://#{domain}/loader25.js";d.head.appendChild(s);}());)
  end
end
