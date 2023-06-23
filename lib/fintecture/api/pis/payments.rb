# frozen_string_literal: true

require 'json'
require 'faraday'
require 'fintecture/endpoints/pis'
require 'fintecture/base_url'

module Fintecture
  module Pis
    class Payments
      class << self
        # ------------ PUBLIC METHOD ------------
        def get(client, session_id, with_virtualbeneficiary: false)
          @client = client

          # Do the get_payments request
          _request session_id, with_virtualbeneficiary: with_virtualbeneficiary
        end

        private

        # ------------ REQUEST ------------
        def _request(session_id, with_virtualbeneficiary: false)
          url = _endpoint

          # Build uri params
          params = {}
          params['with_virtualbeneficiary'] = 'true' if with_virtualbeneficiary

          query_string = "?#{params.map { |key, value| "#{key}=#{value}" }.join('&')}"

          Fintecture::Faraday::Authentication::Connection.get(
            url: "#{url}/#{session_id}" + query_string,
            client: @client,
            custom_content_type: 'application/json',
            bearer: "Bearer #{@client.token}",
            secure_headers: true
          )
        end

        # ------------ API ENDPOINT ------------
        def _endpoint
          "#{_api_base_url}/#{Fintecture::Api::Endpoints::Pis::PAYMENTS}"
        end

        # ------------ BASE URL ------------
        def _api_base_url
          Fintecture::Api::BaseUrl::FINTECTURE_API_URL[@client.environment.to_sym]
        end

      end
    end
  end
end
