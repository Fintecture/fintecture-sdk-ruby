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
    class Authorize
      class << self
        # ------------ PUBLIC METHOD ------------
        def get(client, app_id_auth, provider_id, redirect_uri, state, x_psu_id, x_psu_ip_address)
          @client = client

          # Do the request
          _request app_id_auth, provider_id, redirect_uri, state, x_psu_id, x_psu_ip_address
        end

        private

        # ------------ REQUEST ------------
        def _request(app_id_auth, provider_id, redirect_uri, state, x_psu_id, x_psu_ip_address)
          # Get the url request
          url = _endpoint provider_id

          # Build uri params
          query_string = ''

          params = {}
          params['response_type'] = 'code' if app_id_auth
          params['redirect_uri'] = redirect_uri if redirect_uri
          params['state'] = state if state
          params['model'] = 'redirect'

          query_string = "?#{params.map { |key, value| "#{key}=#{value}" }.join('&')}"

          # Build additional headers
          additional_headers = {}
          additional_headers['app_id'] = @client.app_id if app_id_auth
          additional_headers['x-psu-id'] = x_psu_id if x_psu_id
          additional_headers['x-psu-ip-address'] = x_psu_ip_address if x_psu_ip_address

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
        def _endpoint(provider_id)
          "#{_api_base_url}/#{Fintecture::Api::Endpoints::Ais::AUTHORIZE}/#{provider_id}/authorize"
        end

        # ------------ BASE URL ------------
        def _api_base_url
          Fintecture::Api::BaseUrl::FINTECTURE_API_URL[@client.environment.to_sym]
        end

      end
    end
  end
end
