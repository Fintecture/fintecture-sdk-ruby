# frozen_string_literal: true

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
              faraday.adapter ::Faraday.default_adapter
            end
          end

          def post(url:, req_body: nil, client: nil, custom_content_type: nil, bearer: nil, secure_headers: false, additional_headers: nil, disableAuthorization: nil)
            @client = client
            conn = connection(url)

            res = conn.post do |req|
              req.options.params_encoder = Faraday::DisabledEncoder
              req.headers = req_headers(custom_content_type, bearer, secure_headers, additional_headers, disableAuthorization,
                                        method: 'post', body: req_body, url: url)
              req.body = req_body
            end

            !res.success? ? Fintecture::ApiException.error(res) : res
          end

          def get(url:, req_body: nil, client: nil, custom_content_type: nil, bearer: nil, secure_headers: false, additional_headers: nil, disableAuthorization: nil)
            @client = client
            conn = connection(url)

            res = conn.get do |req|
              req.options.params_encoder = Faraday::DisabledEncoder
              req.headers = req_headers(custom_content_type, bearer, secure_headers, additional_headers, disableAuthorization,
                                         method: 'get', url: url)
              req.body = req_body
            end

            !res.success? ? Fintecture::ApiException.error(res) : res
          end

          def delete(url:, req_body: nil, client: nil, custom_content_type: nil, bearer: nil, secure_headers: false, additional_headers: nil, disableAuthorization: nil)
            @client = client
            conn = connection(url)

            res = conn.delete do |req|
              req.options.params_encoder = Faraday::DisabledEncoder
              req.headers = req_headers(custom_content_type, bearer, secure_headers, additional_headers, disableAuthorization,
                                        method: 'delete', body: req_body, url: url)
              req.body = req_body
            end

            !res.success? ? Fintecture::ApiException.error(res) : res
          end

          def req_headers(custom_content_type, bearer, secure_headers, additional_headers, disableAuthorization, url:, method: '', body: {})
            if !additional_headers.nil? && !additional_headers.is_a?(Hash)
              raise Fintecture::ValidationException, 'additional_headers must be an object'
            end
            client_token = Base64.strict_encode64("#{@client.app_id}:#{@client.app_secret}")

            headers = {
              'Accept' => 'application/json',
              'User-Agent' => "Fintecture Ruby SDK v #{Fintecture::VERSION}",
              'Content-Type' => custom_content_type || 'application/x-www-form-urlencoded'
            }
            headers['Authorization'] =  bearer || "Basic #{client_token}" if !disableAuthorization
            headers = headers.merge(additional_headers) unless additional_headers.nil?
            headers = headers.merge(secure_headers ? req_secure_headers( body: body, url: url, method: method) : {})
            
            # puts headers
            headers
          end

          def req_secure_headers( body: {}, url: '', method: '')

            payload = (body.instance_of?(String) ? body : body.to_s)
            path_name = URI(url).path
            search_params = URI(url).query

            request_target = search_params ? "#{method.downcase} #{path_name}?#{search_params}" : "#{method.downcase} #{path_name}"
            date = Fintecture::Utils::Date.header_time.to_s
            digest = load_digest(payload)
            x_request_id = Fintecture::Utils::Crypto.generate_uuid

            headers = {
              'Date' => date,
              'X-Request-ID' => x_request_id
            }.merge(payload ? digest : {})



            headers['Signature'] =
              Fintecture::Utils::Crypto.create_signature_header(
                { '(request-target)' => request_target }.merge(headers), @client
              )
            headers
          end

          def load_digest(payload)
            { 'Digest' => "SHA-256=#{Fintecture::Utils::Crypto.hash_base64(payload)}" }
          end

          def as_json(element)
            return JSON(element.to_json) if element.is_a? Hash
  
            begin
              element.as_json
            rescue NoMethodError
              raise Fintecture::ValidationException,
                    "invalid parameter format, the parameter should be a Hash or an Object Model instead a #{element.class.name}"
            end
          end

        end
      end
    end

    module DisabledEncoder
      class << self
        extend Forwardable
        def_delegators :'Faraday::Utils', :escape, :unescape
      end

      def self.encode(params)
        return nil if params.nil?

        query_string = params.map { |key, value| "#{key}=#{value}" }.join('&').to_s
      end

      class << self
        attr_accessor :sort_params
      end

      # Useful default for OAuth and caching.
      @sort_params = true
    end
  end
end
