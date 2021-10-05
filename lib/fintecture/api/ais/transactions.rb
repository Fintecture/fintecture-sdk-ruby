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
    class Transactions
      class << self
        # ------------ PUBLIC METHOD ------------
        def get(client, customer_id, account_id, remove_nulls, convert_dates, filters)
          @client = client

          # Do the request
          _request customer_id, account_id, remove_nulls, convert_dates, filters
        end

        private

        # ------------ REQUEST ------------
        def _request(customer_id, account_id, remove_nulls, convert_dates, filters)
          # Get the url request
          url = _endpoint customer_id, account_id

          # Build uri params
          query_string = ""
          if remove_nulls || convert_dates || filters
            params = {}
            params['remove_nulls'] = remove_nulls if remove_nulls
            params['convert_dates'] = convert_dates if convert_dates
            filters.each{|key, value| params[key] = value } if filters
            
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
        def _endpoint (customer_id, account_id)
          "#{_api_base_url}/#{Fintecture::Api::Endpoints::Ais::TRANSACTIONS}/#{customer_id}/accounts/#{account_id}/transactions"
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
