require 'json'
require 'faraday'

module Fintecture
  class Pis
    class << self

      def prepare_payload(payload, access_token)
        url = prepare_payload_endpoint

        Fintecture::Faraday::Authentication::Connection.post(
            url: url,
            req_body: payload.to_json,
            custom_content_type: 'application/json',
            bearer: "Bearer #{access_token}"
        )
      end

      def get_access_token
       Fintecture::Authentication.access_token
      end

      private

      def prepare_payload_endpoint
        "#{api_base_url}/pis/v1/prepare"
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