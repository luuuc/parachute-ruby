module Parachute
  class Notifier
    def initialize
      Rails.logger.debug "-> Parachute::Notifier.initialize"
      @default_options = {
        url: 'http://parachute.dev/api/v1/notices',
        http_method: :post
      }
    end

    # TODO: split & organize ...
    def call(exception, options = {})
      env = options[:env]

      options = options.reverse_merge(@default_options)
      url = options.delete(:url)
      http_method = options.delete(:http_method) || :post

      options[:notice] ||= {}
      options[:notice][:server] = Socket.gethostname
      options[:notice][:process] = $$
      if defined?(Rails) && Rails.respond_to?(:root)
        options[:notice][:rails_root] = Rails.root
      end
      options[:notice][:exception] = {
        error_class: exception.class.to_s,
        message: exception.message.inspect,
        backtrace: exception.backtrace
      }
      options[:notice][:data] = (env['exception_notifier.exception_data'] || {}).merge(options[:data] || {})

      unless env.nil?
        request = ActionDispatch::Request.new(env)

        request_items = {
          url: request.original_url,
          http_method: request.method,
          ip_address: request.remote_ip,
          parameters: request.filtered_parameters,
          timestamp: Time.current
        }

        options[:notice][:request] = request_items
        options[:notice][:session] = request.session
        options[:notice][:environment] = request.filtered_env
      end

      uri = URI(url)
      http_client = Net::HTTP.new(uri.host, uri.port)
      http_post = Net::HTTP::Post.new(uri).tap do |request|
        request['Content-Type'] = 'application/json; charset=UTF-8'
        request['Content-Encoding'] = 'gzip'
        request.body = Zlib::Deflate.deflate(
          JSON.generate({ notice: options[:notice] }, quirks_mode: true),
          Zlib::BEST_SPEED
        )
      end

      http_client.request(http_post).code
    end
  end
end
