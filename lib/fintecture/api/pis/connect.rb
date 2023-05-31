# frozen_string_literal: true

require 'base64'
require 'json'
require 'faraday'
require 'fintecture/utils/validation'
require 'fintecture/exceptions'
require 'fintecture/utils/date'
require 'fintecture/utils/constants'

module Fintecture
  module Pis
    class Connect
      class << self
        # ------------ PUBLIC METHOD ------------
        def generate(client, payload, state, redirect_uri, origin_uri, **options)

          @client = client

          # Build the request payload
          payload = _build_payload(payload)

          # Do the request
          _request payload, state, redirect_uri, origin_uri, options
        end

        private

        # ------------ REQUEST ------------
        def _request(payload, state, redirect_uri, origin_uri, options)
          defaults = {
            :with_virtualbeneficiary => false
          }
          options = defaults.merge(options)

          # Get the url request
          url = _endpoint

          # Build uri params
          params = {}
          params['redirect_uri'] = redirect_uri if redirect_uri
          params['origin_uri'] = origin_uri if origin_uri
          params['with_virtualbeneficiary'] = 'true' if options[:with_virtualbeneficiary]
          params['state'] = state

          query_string = "?#{params.map { |key, value| "#{key}=#{value}" }.join('&')}"

          # Do connect request
          Fintecture::Faraday::Authentication::Connection.post(
            url: url + query_string,
            req_body: payload.to_json,
            client: @client,
            custom_content_type: 'application/json',
            bearer: "Bearer #{@client.token}",
            secure_headers: true
          )
        end

        # ------------ BUILD PAYLOAD ------------
        def _build_payload(payload)
          payload[:data][:attributes][:amount] = payload[:data][:attributes][:amount].to_s

          unless payload[:data][:attributes][:end_to_end_id]
            payload[:data][:attributes][:end_to_end_id] =
              Fintecture::Utils::Crypto.generate_uuid_only_chars
          end

          payload
        end

        # ------------ API ENDPOINT ------------
        def _endpoint
          "#{_api_base_url}/#{Fintecture::Api::Endpoints::Pis::CONNECT}"
        end

        # ------------ BASE URL ------------
        def _api_base_url
          Fintecture::Api::BaseUrl::FINTECTURE_API_URL[@client.environment.to_sym]
        end

      end
    end
  end
end
