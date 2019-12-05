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

        Faraday.get "#{token_authorize_endpoint}#{query_string}"
      end

      def access_token(auth_code =  nil)
        body = access_token_data auth_code

        post url: access_toke_url, req_body: body
      end

      def refresh_token(refresh_token)
        body = refresh_token_data refresh_token

        post url: refresh_token_url, req_body: body
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

      def faraday_connection(url)
        Faraday.new(url: url) do |faraday|
          faraday.request :url_encoded
          faraday.adapter  Faraday.default_adapter
        end
      end

      def post(url:, req_body:)
        conn = faraday_connection(url)

        conn.post do |req|
          req.headers = headers
          req.body = req_body
        end
      end

      def headers
        client_token = Base64.strict_encode64("#{Fintecture.app_id}:#{Fintecture.app_secret}")

        {
            'Accept' => 'application/json',
            'User-Agent' => "Fintecture Ruby SDK v #{Fintecture::VERSION}",
            'Authorization' => "Basic #{client_token}",
            'Content-Type' => 'application/x-www-form-urlencoded',
        }
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