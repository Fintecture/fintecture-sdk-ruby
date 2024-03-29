# frozen_string_literal: true

require 'json'
require 'faraday'

module Fintecture
  class Authentication
    class << self
      def authorize(redirect_uri, state = nil)
        query_string = "?#{{
          response_type: 'code',
          app_id: Fintecture.app_id,
          redirect_uri: redirect_uri,
          state: state
        }.map { |key, value| "#{key}=#{value}" }.join('&')}"

        ::Faraday.get "#{token_authorize_endpoint}#{query_string}"
      end

      def get_access_token(client, auth_code = nil)
        @client = client
        body = access_token_data auth_code

        Fintecture::Faraday::Authentication::Connection.post url: access_token_url, req_body: body, client: client
      end

      def refresh_token(client, refresh_token)
        @client = client
        body = refresh_token_data refresh_token

        Fintecture::Faraday::Authentication::Connection.post url: refresh_token_url, req_body: body, client: client
      end

      private

      def base_url
        Fintecture::Api::BaseUrl::FINTECTURE_OAUTH_URL[@client.environment.to_sym]
      end

      def token_authorize_endpoint
        "#{base_url}#{Fintecture::Api::Endpoints::Authentication::OAUTH_TOKEN_AUTHORIZE}"
      end

      def access_token_url
        "#{base_url}#{Fintecture::Api::Endpoints::Authentication::OAUTH_ACCESS_TOKEN}"
      end

      def refresh_token_url
        "#{base_url}#{Fintecture::Api::Endpoints::Authentication::OAUTH_REFRESH_TOKEN}"
      end

      def access_token_data(auth_code)
        data = {
          scope: 'PIS',
          app_id: @client.app_id,
          grant_type: 'client_credentials'
        }

        if auth_code
          data = {
            scope: 'AIS',
            code: auth_code,
            grant_type: 'authorization_code'
          }
        end

        data
      end

      def refresh_token_data(refresh_token)
        {
          grant_type: 'refresh_token',
          refresh_token: refresh_token
        }
      end
    end
  end
end
