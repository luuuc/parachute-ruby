module Parachute
  module Integration
    class Railtie < ::Rails::Railtie
      config.app_middleware.use Parachute::Middleware::Rack
    end
  end
end
