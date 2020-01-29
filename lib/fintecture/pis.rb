require 'json'
require 'faraday'
require 'fintecture/api/endpoints/pis'
require 'fintecture/api/base_url'

module Fintecture
  class Pis
    class << self

      # Headers
      def prepare_payment(access_token, payload)
        url = prepare_payment_endpoint

        Fintecture::Faraday::Authentication::Connection.post(
            url: url,
            req_body: payload.to_json,
            custom_content_type: 'application/json',
            bearer: "Bearer #{access_token}",
            secure_headers: true
        )
      end

      # This needs headers
      def get_payments(access_token, session_id)
        url = payment_endpoint

        Fintecture::Faraday::Authentication::Connection.get(
            url: "#{url}/#{session_id}",
            custom_content_type: 'application/json',
            bearer: "Bearer #{access_token}",
            secure_headers: true
        )
      end

      def get_access_token
        response = Fintecture::Authentication.get_access_token

        JSON.parse response.body
      end

      private

      def prepare_payment_endpoint
        "#{api_base_url}/#{Fintecture::Api::Endpoints::Pis::PREPARE}"
      end

      def payment_endpoint
        "#{api_base_url}/#{Fintecture::Api::Endpoints::Pis::PAYMENTS}"
      end

      def base_url
        Fintecture::Api::BaseUrl::FINTECTURE_CONNECT_URL[Fintecture.environment.to_sym]
      end

      def api_base_url
        Fintecture::Api::BaseUrl::FINTECTURE_API_URL[Fintecture.environment.to_sym]
      end

    end
  end
end