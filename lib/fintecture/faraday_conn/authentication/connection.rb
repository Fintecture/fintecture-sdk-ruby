require 'base64'

module Fintecture
  module Faraday
    module Authentication
      module Connection
        private

        def connection(endpoint, timeout: nil, proxy: nil, open_timeout: nil, logger: nil, ca_path: nil, ca_file: nil)
          client_token = Base64.strict_encode64("#{Fintecture.app_id}:#{Fintecture.app_secret}")
          options = {
              headers: {
                  'Accept' => 'application/json',
                  'User-Agent' => "Fintecture Ruby SDK v #{Fintecture::VERSION}",
                  'Authorization' => "Basic #{client_token}",
                  'Content-Type' => 'application/x-www-form-urlencoded',
              }
          }

          options[:proxy] = proxy if proxy
          options[:ssl] = { ca_path: ca_path, ca_file: ca_file } if ca_path && ca_file

          request_options = {}
          request_options[:timeout] = timeout if timeout
          request_options[:opercn_timeout] = open_timeout if open_timeout
          options[:request] = request_options if request_options.any?

          ::Faraday::Connection.new(endpoint, options) do |connection|
            connection.use ::Faraday::Request::Multipart
            connection.use ::Faraday::Request::UrlEncoded
            connection.use ::Faraday::Response::RaiseError
            connection.use ::FaradayMiddleware::ParseJson
            connection.response :logger, logger if logger
            connection.adapter ::Faraday.default_adapter
          end
        end
      end
    end
  end
end
