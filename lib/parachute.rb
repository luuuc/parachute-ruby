require 'net/http'
require 'json'
require 'logger'
# require 'active_support/core_ext/string/inflections'
# require 'active_support/core_ext/module/attribute_accessors'
require 'action_dispatch'

require "parachute/version"
#require 'parachute/configuration'
require 'parachute/middleware/rack'
require "parachute/notifier"
require 'parachute/integration/rails' if defined?(::Rails::Railtie)

module Parachute
  class << self
    def notify_exception(exception, options={})
      Rails.logger.debug "-> Parachute.notify_exception"
      notifier = Parachute::Notifier.new
      notifier.call(exception, options.dup)

      true
    end
  end
end
