require 'base64'
require 'faraday'

module Fintecture
  module Faraday
    module Authentication
      class Connection
        class << self

          def connection(url)
            ::Faraday.new(url: url) do |faraday|
              faraday.request :url_encoded
              faraday.adapter  ::Faraday.default_adapter
            end
          end

          def post(url:, req_body:)
            conn = connection(url)

            conn.post do |req|
              req.headers = req_headers
              req.body = req_body
            end
          end

          def req_headers
            client_token = Base64.strict_encode64("#{Fintecture.app_id}:#{Fintecture.app_secret}")

            {
                'Accept' => 'application/json',
                'User-Agent' => "Fintecture Ruby SDK v #{Fintecture::VERSION}",
                'Authorization' => "Basic #{client_token}",
                'Content-Type' => 'application/x-www-form-urlencoded',
            }
          end

        end
      end
    end
  end
end
