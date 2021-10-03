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
    class DeleteCustomer

      class << self
        # ------------ PUBLIC METHOD ------------
        def delete(client, customer_id)
          @client = client

          # Do the request
          _request customer_id
        end

        private

        # ------------ REQUEST ------------
        def _request(customer_id)
          # Get the url request
          url = _endpoint customer_id


          
          # Do connect request
          Fintecture::Faraday::Authentication::Connection.delete(
            url: url ,
            client: @client,
            custom_content_type: 'application/json',
            bearer: "Bearer #{@client.token}",
            secure_headers: true
          )
        end



        # ------------ API ENDPOINT ------------
        def _endpoint (customer_id)
          "#{_api_base_url}/#{Fintecture::Api::Endpoints::Ais::CUSTOMER}/#{customer_id}"
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
