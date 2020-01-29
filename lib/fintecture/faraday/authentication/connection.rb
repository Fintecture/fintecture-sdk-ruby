require 'base64'
require 'faraday'
require 'uri'
require 'fintecture/utils/crypto'
require 'fintecture/utils/date'

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
              req.headers = req_headers(custom_content_type, bearer, secure_headers, method: 'post', body: req_body, url: url)
              req.body = req_body
            end
          end

          def get(url:, req_body: nil, custom_content_type: nil, bearer: nil, secure_headers: false)
            conn = connection(url)

            conn.get do |req|
              req.headers = req_headers(custom_content_type, bearer, secure_headers, method: 'get', url: url)
              req.body = req_body
            end
          end

          def req_headers(custom_content_type, bearer, secure_headers, method: '', body: {}, url:)
            client_token = Base64.strict_encode64("#{Fintecture.app_id}:#{Fintecture.app_secret}")

            {
                'Accept' => 'application/json',
                'User-Agent' => "Fintecture Ruby SDK v #{Fintecture::VERSION}",
                'Authorization' => bearer ? bearer : "Basic #{client_token}",
                'Content-Type' => custom_content_type ? custom_content_type : 'application/x-www-form-urlencoded',
            }.merge(secure_headers ? req_secure_headers(body: body, url: url, method: method) : {})

          end

          def req_secure_headers(body: {}, url: '', method: '')
            payload = ( body.class.name == 'String' ? body : body.to_s )
            path_name = URI(url).path
            headers = {
                'Date' => Fintecture::Utils::Date.header_time.to_s,
                'X-Request-Id' => Fintecture::Utils::Crypto.generate_uuid
            }.merge(payload ? load_digest(payload) : {})

            headers['Signature'] = Fintecture::Utils::Crypto.create_signature_header({'(request-target)' => "#{method.downcase} #{path_name}"}.merge(headers))
            headers
          end

          def load_digest(payload)
            {'Digest' => "SHA-256=#{Fintecture::Utils::Crypto.hash_base64(payload)}"}
          end

        end
      end
    end
  end
end
