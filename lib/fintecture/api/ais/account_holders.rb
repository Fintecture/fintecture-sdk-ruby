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
    class AccountHolders
      class << self
        # ------------ PUBLIC METHOD ------------
        def get(client, customer_id, remove_nulls)
          @client = client

          # Do the request
          _request customer_id, remove_nulls
        end

        private

        # ------------ REQUEST ------------
        def _request(customer_id, remove_nulls)
          # Get the url request
          url = _endpoint customer_id

          # Build uri params
          query_string = ''
          if remove_nulls
            params = {}
            params['remove_nulls'] = remove_nulls if remove_nulls
            query_string = "?#{params.map { |key, value| "#{key}=#{value}" }.join('&')}"
          end

          # Do connect request
          Fintecture::Faraday::Authentication::Connection.get(
            url: url + query_string,
            client: @client,
            custom_content_type: 'application/json',
            bearer: "Bearer #{@client.token}",
            secure_headers: true
          )
        end

        # ------------ API ENDPOINT ------------
        def _endpoint(customer_id)
          "#{_api_base_url}/#{Fintecture::Api::Endpoints::Ais::ACCOUNTHOLDERS}/#{customer_id}/accountholders"
        end

        # ------------ BASE URL ------------
        def _api_base_url
          Fintecture::Api::BaseUrl::FINTECTURE_API_URL[@client.environment.to_sym]
        end

      end
    end
  end
end
