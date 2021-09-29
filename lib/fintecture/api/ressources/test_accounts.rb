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
    class TestAccounts
      class << self
        # ------------ PUBLIC METHOD ------------
        def get(client, provider_id)
          @client = client

          # Do the request
          _request provider_id
        end

        private

        # ------------ REQUEST ------------
        def _request(provider_id)
          # Get the url request
          url = _endpoint

          # Build additional headers
          additional_headers = {}
          additional_headers['app_id'] = @client.app_id

          # Build uri params
          query_string = ''
          query_string = "?filter[provider_id]=#{provider_id}" if provider_id
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
          "#{_api_base_url}/#{Fintecture::Api::Endpoints::Ressources::TESTACCOUNTS}"
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
