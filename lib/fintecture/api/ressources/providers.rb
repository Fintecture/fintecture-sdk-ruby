# frozen_string_literal: true

require 'base64'
require 'json'
require 'faraday'
require 'fintecture/utils/validation'
require 'fintecture/exceptions'
require 'fintecture/utils/date'
require 'fintecture/utils/constants'

module Fintecture
  module Ressources
    class Providers
      class << self
        # ------------ PUBLIC METHOD ------------
        def get(client, provider_id, paramsProviders)
          @client = client

          # Do the request
          _request provider_id, paramsProviders
        end

        private

        # ------------ REQUEST ------------
        def _request(provider_id, paramsProviders)
          # Get the url request
          url = _endpoint provider_id

          # Build additional headers
          additional_headers = {}
          additional_headers['app_id'] = @client.app_id

          # Build uri params
          query_string = ''
          query_string = "?#{paramsProviders.map { |key, value| "#{key}=#{value}" }.join('&')}" if paramsProviders

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
        def _endpoint(provider_id)
          "#{_api_base_url}/#{Fintecture::Api::Endpoints::Ressources::PROVIDERS}/#{provider_id || ''}"
        end

        # ------------ BASE URL ------------
        def _api_base_url
          Fintecture::Api::BaseUrl::FINTECTURE_API_URL[@client.environment.to_sym]
        end

      end
    end
  end
end
