# frozen_string_literal: true

require 'base64'
require 'json'
require 'faraday'
require 'fintecture/utils/validation'
require 'fintecture/exceptions'
require 'fintecture/utils/date'
require 'fintecture/utils/constants'

module Fintecture
  module Ais
    class Connect
      class << self
        # ------------ PUBLIC METHOD ------------
        def generate(client, state, redirect_uri, scope)
          @client = client

          # Do the request
          _request state, redirect_uri, scope
        end

        private

        # ------------ REQUEST ------------
        def _request(state, redirect_uri, scope)
          # Get the url request
          url = _endpoint

          # Build uri params
          params = {}
          params['state'] = state
          params['redirect_uri'] = redirect_uri
          params['scope'] = scope if scope

          query_string = "?#{params.map { |key, value| "#{key}=#{value}" }.join('&')}"

          # Build additional headers
          additional_headers = {}
          additional_headers['app_id'] = @client.app_id

          # Do connect request
          Fintecture::Faraday::Authentication::Connection.get(
            url: url + query_string,
            client: @client,
            custom_content_type: 'application/json',
            secure_headers: true,
            additional_headers: additional_headers
          )
        end

        # ------------ API ENDPOINT ------------
        def _endpoint
          "#{_api_base_url}/#{Fintecture::Api::Endpoints::Ais::CONNECT}"
        end

        # ------------ BASE URL ------------
        def _api_base_url
          Fintecture::Api::BaseUrl::FINTECTURE_API_URL[@client.environment.to_sym]
        end

      end
    end
  end
end
