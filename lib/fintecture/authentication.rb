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
        }.map{|key, value| "#{key}=#{value}"}.join('&')}"

        ::Faraday.get "#{token_authorize_endpoint}#{query_string}"
      end

      def access_token(auth_code =  nil)
        body = access_token_data auth_code

        Fintecture::Faraday::Authentication::Connection.post url: access_toke_url, req_body: body
      end

      def refresh_token(refresh_token)
        body = refresh_token_data refresh_token

        Fintecture::Faraday::Authentication::Connection.post url: refresh_token_url, req_body: body
      end

      private

      def base_url
        Fintecture::Api::BaseUrl::FINTECTURE_OAUTH_URL[Fintecture.environment.to_sym]
      end

      def token_authorize_endpoint
        "#{base_url}#{Fintecture::Api::Endpoints::Authentication::OAUTH_TOKEN_AUTHORIZE}"
      end

      def access_toke_url
        "#{base_url}#{Fintecture::Api::Endpoints::Authentication::OAUTH_ACCESS_TOKEN}"
      end

      def refresh_token_url
        "#{base_url}#{Fintecture::Api::Endpoints::Authentication::OAUTH_REFRESH_TOKEN}"
      end

      def access_token_data(auth_code)
        data =  {
            scope: 'PIS',
            app_id: Fintecture.app_id,
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
        data = {
            grant_type: 'refresh_token',
            refresh_token: refresh_token
        }
        data
      end

    end
  end
end