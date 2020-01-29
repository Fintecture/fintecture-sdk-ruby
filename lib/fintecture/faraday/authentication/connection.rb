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

          def post(url:, req_body: nil, custom_content_type: nil, bearer: nil, secure_headers: false)
            conn = connection(url)

            conn.post do |req|
              req.headers = req_headers(custom_content_type, bearer, secure_headers)
              req.body = req_body
            end
          end

          def get(url:, req_body: nil, custom_content_type: nil, bearer: nil, secure_headers: false)
            conn = connection(url)

            conn.get do |req|
              req.headers = req_headers(custom_content_type, bearer, secure_headers)
              req.body = req_body
            end
          end

          def req_headers(custom_content_type, bearer, secure_headers)
            client_token = Base64.strict_encode64("#{Fintecture.app_id}:#{Fintecture.app_secret}")

            min_headers = {
                'Accept' => 'application/json',
                'User-Agent' => "Fintecture Ruby SDK v #{Fintecture::VERSION}",
                'Authorization' => bearer ? bearer : "Basic #{client_token}",
                'Content-Type' => custom_content_type ? custom_content_type : 'application/x-www-form-urlencoded',
            }

            min_headers
          end

        end
      end
    end
  end
end
