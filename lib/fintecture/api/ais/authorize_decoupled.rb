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
    class AuthorizeDecoupled
      class << self
        # ------------ PUBLIC METHOD ------------
        def get(client, app_id_auth, provider_id, polling_id)
          @client = client

          # Do the request
          _request app_id_auth, provider_id, polling_id
        end

        private

        # ------------ REQUEST ------------
        def _request(app_id_auth, provider_id, polling_id)
          # Get the url request
          url = _endpoint provider_id, polling_id

          # Build uri params
          query_string = ''

          params = {}
          params['response_type'] = 'code' if app_id_auth
          params['model'] = 'decoupled'

          query_string = "?#{params.map { |key, value| "#{key}=#{value}" }.join('&')}"

          # Build additional headers
          additional_headers = {}
          additional_headers['app_id'] = @client.app_id if app_id_auth

          # Do connect request
          Fintecture::Faraday::Authentication::Connection.get(
            url: url + query_string,
            client: @client,
            custom_content_type: 'application/json',
            bearer: "Bearer #{@client.token}",
            secure_headers: true,
            additional_headers: additional_headers,
            disableAuthorization: app_id_auth ? true : false
          )
        end

        # ------------ API ENDPOINT ------------
        def _endpoint(provider_id, polling_id)
          "#{_api_base_url}/#{Fintecture::Api::Endpoints::Ais::AUTHORIZE}/#{provider_id}/authorize/decoupled/#{polling_id}"
        end

        # ------------ BASE URL ------------
        def _api_base_url
          Fintecture::Api::BaseUrl::FINTECTURE_API_URL[@client.environment.to_sym]
        end

        # ------------ TOOLS ------------
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
end
