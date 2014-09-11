module Parachute
  module Middleware
    class Rack
      def initialize(app, options = {})
        @app = app

        #Parachute::Notifier.new(options)
      end

      def call(env)
        @app.call(env)
      rescue Exception => exception
        if Parachute.notify_exception(exception, env: env)
          env['exception_notifier.delivered'] = true
        end
        raise exception
      end
    end
  end
end
