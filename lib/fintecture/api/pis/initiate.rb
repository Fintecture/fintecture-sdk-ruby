# frozen_string_literal: true

module Fintecture
  module Pis
    class Initiate
      class << self
        # ------------ PUBLIC METHOD ------------
        def generate(client, payload, provider_id, redirect_uri, state)
          @client = client

          # Do the _request request
          _request payload, provider_id, redirect_uri, state
        end

        private

        # ------------ REQUEST ------------
        def _request(payload, provider_id, redirect_uri, state)
          # Get the url request
          url = _endpoint provider_id

          # Build uri params
          params = {}
          params['state'] = state
          params['redirect_uri'] = redirect_uri
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

        # ------------ API ENDPOINT ------------
        def _endpoint(provider_id)
          "#{_api_base_url}/#{Fintecture::Api::Endpoints::Pis::INITIATE}/#{provider_id}/initiate"
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
