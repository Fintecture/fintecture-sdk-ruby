# frozen_string_literal: true

require 'json'
require 'faraday'
require 'fintecture/endpoints/pis'
require 'fintecture/base_url'
module Fintecture
  module Pis
    class Refund
      class << self
        # ------------ PUBLIC METHOD ------------
        def generate(client, session_id, amount, user_id)
          @client = client

          # Build the request payload
          payload = _build_payload session_id, amount, user_id
          # Do the _request request
          _request payload
        end

        private

        # ------------ REQUEST ------------
        def _request(payload)
          # Get the url request
          url = _endpoint

          # Do connect request
          Fintecture::Faraday::Authentication::Connection.post(
            url: url,
            req_body: payload.to_json,
            client: @client,
            custom_content_type: 'application/json',
            bearer: "Bearer #{@client.token}",
            secure_headers: true
          )
        end

        # ------------ BUILD PAYLOAD ------------
        def _build_payload(session_id, amount, user_id)
          # Return the payload
          {
            meta: {
              session_id: session_id,
              user_id: user_id
            },
            data: {
              attributes: {
                amount: amount.to_s
              }
            }
          }
        end

        # ------------ API ENDPOINT ------------
        def _endpoint
          "#{_api_base_url}/#{Fintecture::Api::Endpoints::Pis::REFUND}"
        end

        # ------------ BASE URL ------------
        def _api_base_url
          Fintecture::Api::BaseUrl::FINTECTURE_API_URL[@client.environment.to_sym]
        end
      end
    end
  end
end
