require 'json'
require 'faraday'
require 'fintecture/api/endpoints/pis'
require 'fintecture/api/base_url'

module Fintecture
  class Pis
    class << self
      

      # ------------ PUBLIC METHODS ------------
      # Connect
      def get_connect(access_token = nil, payment_attrs = nil)
        payment_attrs = as_json payment_attrs

        # Build the request payload
        payload = build_payload_connect(payment_attrs)
        # Do the _get_connect_request request
        _get_connect_request access_token, payload, payment_attrs
      end

      # Request_to_pay
      def request_to_pay(access_token = nil, payment_attrs = nil)
        payment_attrs = as_json payment_attrs

        # Build the request payload
        payload = build_payload_request_to_pay(as_json payment_attrs)
        # Do the _request_to_pay_request request
        _request_to_pay_request access_token, payload, payment_attrs
      end

      # Get_payments
      def get_payments(access_token = nil, session_id = nil)
        # Do the get_payments request
        _get_payments_request access_token, session_id
      end

      # Get_access_token
      def get_access_token
        # Do the get_access_token request
        response = Fintecture::Authentication.get_access_token
        JSON.parse response.body
      end

      


      private
      # ------------ REQUESTS ------------
      # Connect
      def _get_connect_request(access_token, payload, payment_attrs)

        # Get the url request
        url = connect_endpoint

        # Build uri params
        params = {}
        params['state'] = payment_attrs['state']
        params['redirect_uri'] = payment_attrs['redirect_uri'] if payment_attrs['redirect_uri'] 
        query_string = "?#{params.map{|key, value| "#{key}=#{value}"}.join('&')}"

        # Do connect request
        Fintecture::Faraday::Authentication::Connection.post(
            url: url + query_string, 
            req_body: payload.to_json,
            custom_content_type: 'application/json',
            bearer: "Bearer #{access_token}",
            secure_headers: true
        )
      end

      # Request_to_pay
      def _request_to_pay_request(access_token, payload, payment_attrs)

        # Get the url request
        url = request_to_pay_endpoint

        additional_headers = {}
        additional_headers['x-language'] = payment_attrs['x_language']

        # Do connect request
        Fintecture::Faraday::Authentication::Connection.post(
            url: url,
            req_body: payload.to_json,
            custom_content_type: 'application/json',
            bearer: "Bearer #{access_token}",
            secure_headers: true,
            additional_headers: additional_headers
        )
      end

      # Get_payments
      def _get_payments_request(access_token, session_id)
        url = payment_endpoint

        Fintecture::Faraday::Authentication::Connection.get(
            url: "#{url}/#{session_id}",
            custom_content_type: 'application/json',
            bearer: "Bearer #{access_token}",
            secure_headers: true
        )
      end

  


      # ------------ BUILD PAYLOADS ------------
      # Connect - Build the payload from payment_attrs
      def build_payload_connect(payment_attrs = nil)
        # Mandatory attributes
        attributes = {
            amount: payment_attrs['amount'].to_s,
            currency: payment_attrs['currency'],
            communication: payment_attrs['communication'],
            end_to_end_id: payment_attrs['end_to_end_id'] || Fintecture::Utils::Crypto.generate_uuid_only_chars
        }
    
        # Optionals attributes
        attributes['execution_date'] = payment_attrs['execution_date'] if payment_attrs['execution_date']
        attributes['debited_account_id'] = payment_attrs['debited_account_id'] if payment_attrs['debited_account_id']
        attributes['debited_account_type'] = payment_attrs['debited_account_type'] if payment_attrs['debited_account_type']
        attributes['scheme'] = payment_attrs['scheme'] if payment_attrs['scheme']
        
        # Mandatory attributes => beneficiary
        if payment_attrs['beneficiary']
          attributes['beneficiary'] = {
            name: payment_attrs['beneficiary']['name'],
            street: payment_attrs['beneficiary']['street'],
            zip: payment_attrs['beneficiary']['zip'],
            city: payment_attrs['beneficiary']['city'],
            country: payment_attrs['beneficiary']['country'],
            iban: payment_attrs['beneficiary']['iban'],
            swift_bic: payment_attrs['beneficiary']['swift_bic']
          }

          # Optionals attributes => beneficiary
          attributes['beneficiary']['number'] = payment_attrs['beneficiary']['number'] if payment_attrs['beneficiary']['number']
          attributes['beneficiary']['complement'] = payment_attrs['beneficiary']['complement'] if payment_attrs['beneficiary']['complement']
          attributes['beneficiary']['form'] = payment_attrs['beneficiary']['form'] if payment_attrs['beneficiary']['form']
          attributes['beneficiary']['incorporation'] = payment_attrs['beneficiary']['incorporation'] if payment_attrs['beneficiary']['incorporation']
        end

        # Mandatory meta data
        meta = {
            psu_name: payment_attrs['customer_full_name'],
            psu_email: payment_attrs['customer_email'],
            psu_phone: payment_attrs['customer_phone']
        }

        # Optionals meta data
        meta['psu_phone_prefix'] = payment_attrs['customer_phone_prefix'] if payment_attrs['customer_phone_prefix']
        meta['psu_ip'] = payment_attrs['customer_ip'] if payment_attrs['customer_ip']

        # Mandatory meta => psu_address
        meta['psu_address'] = {
          street:  payment_attrs['customer_address']['street'], 
          city:  payment_attrs['customer_address']['city'],
          zip: payment_attrs['customer_address']['zip'],
          country: payment_attrs['customer_address']['country'] 
        }

        # Optionals meta => psu_address
        meta['psu_address']['number'] = payment_attrs['customer_address']['number'] if payment_attrs['customer_address']['number']
        meta['psu_address']['complement'] = payment_attrs['customer_address']['complement'] if payment_attrs['customer_address']['complement']

        # Return the payload
        {
            meta: meta,
            data: {
              type: 'PIS',
              attributes: attributes,
          }
        }
      end

      # Request_to_pay - Build the payload from payment_attrs
      def build_payload_request_to_pay(payment_attrs = nil)
        # Mandatory attributes
        attributes = {
            amount: payment_attrs['amount'],
            currency: payment_attrs['currency'],
            communication: payment_attrs['communication']
        }
    
        # Mandatory meta data
        meta = {
            psu_name: payment_attrs['customer_full_name'],
            psu_email: payment_attrs['customer_email'],
            psu_phone: payment_attrs['customer_phone'],
            psu_phone_prefix: payment_attrs['customer_phone_prefix'] 
        }

        # Optionals meta psu_address
        if payment_attrs['customer_address']
          meta['psu_address'] = {}
          meta['psu_address']['street'] = payment_attrs['customer_address']['street'] if payment_attrs['customer_address']['street']
          meta['psu_address']['number'] = payment_attrs['customer_address']['number'] if payment_attrs['customer_address']['number']
          meta['psu_address']['city'] = payment_attrs['customer_address']['city'] if payment_attrs['customer_address']['city']
          meta['psu_address']['zip'] = payment_attrs['customer_address']['zip'] if payment_attrs['customer_address']['zip']
          meta['psu_address']['country'] = payment_attrs['customer_address']['country'] if payment_attrs['customer_address']['country']
        end

        # Optionals meta data
        meta['expirary'] = payment_attrs['expirary'] if payment_attrs['expirary']
        meta['cc'] = payment_attrs['cc'] if payment_attrs['cc']
        meta['bcc'] = payment_attrs['bcc'] if payment_attrs['bcc']


        # Return the payload
        {
            meta: meta,
            data: {
              type: 'REQUEST_TO_PAY',
              attributes: attributes,
          }
        }
      end




      # ------------ API ENDPOINTS ------------
      # Request_to_pay
      def request_to_pay_endpoint
        "#{api_base_url}/#{Fintecture::Api::Endpoints::Pis::REQUEST_TO_PAY}"
      end

      # Payment
      def payment_endpoint
        "#{api_base_url}/#{Fintecture::Api::Endpoints::Pis::PAYMENTS}"
      end

      # Connect
      def connect_endpoint
        "#{api_base_url}/#{Fintecture::Api::Endpoints::Pis::CONNECT}"
      end

      


      # ------------ BASE URL ------------
      def base_url
        Fintecture::Api::BaseUrl::FINTECTURE_CONNECT_URL[Fintecture.environment.to_sym]
      end

      def api_base_url
        Fintecture::Api::BaseUrl::FINTECTURE_API_URL[Fintecture.environment.to_sym]
      end



      # ------------ TOOLS ------------
      def as_json(element)
        return JSON(element.to_json) if element.is_a? Hash

        begin
          element.as_json
        rescue NoMethodError
          raise Fintecture::ValidationException.new("invalid parameter format, the parameter should be a Hash or an Object Model instead a #{element.class.name}")
        end
      end
    end
  end
end