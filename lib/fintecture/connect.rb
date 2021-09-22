require 'base64'
require 'json'
require 'faraday'
require 'fintecture/pis'
require 'fintecture/utils/validation'
require 'fintecture/exceptions'
require 'fintecture/utils/date'
require 'fintecture/utils/constants'

module Fintecture
  class Connect
    class << self
      SIGNATURE_TYPE = 'rsa-sha256'.freeze

      # Start the process
      def get_pis_connect(access_token = nil, payment_attrs = nil)
        connect_url(access_token, payment_attrs)
      end

      # Main process for construct the request to get a connect url
      def connect_url(access_token = nil, payment_attrs = nil)
        @access_token = access_token
        @payment_attrs = as_json payment_attrs
  
        # Build the request payload
        payload = build_payload
        # Do the connect request
        connect_response = connect access_token, payload
        # Parse the result
        connect_response_body = JSON.parse connect_response.body


        {
            url: connect_response_body['meta']['url'],
            session_id: connect_response_body['meta']['session_id']
        }
      end

      # Api call for get a connect url
      def connect(access_token, payload)

        # Get the url request
        url = connect_endpoint
        
        # Build uri params
        params = {}
        params['state'] = @payment_attrs['state']
        params['redirect_uri'] = @payment_attrs['redirect_uri'] if @payment_attrs['redirect_uri'] 
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

      # Build the endpoint for connect route
      def connect_endpoint
        "#{api_base_url}/#{Fintecture::Api::Endpoints::Pis::CONNECT}"
      end

      # Build the base of url
      def api_base_url
        Fintecture::Api::BaseUrl::FINTECTURE_API_URL[Fintecture.environment.to_sym]
      end


      private


      # Build the payload from payment_attrs
      def build_payload
        # Mandatory attributes
        attributes = {
            amount: @payment_attrs['amount'].to_s,
            currency: @payment_attrs['currency'],
            communication: @payment_attrs['communication'],
            end_to_end_id: @payment_attrs['end_to_end_id'] || Fintecture::Utils::Crypto.generate_uuid_only_chars
        }
    

        # Optionals attributes
        attributes['execution_date'] = @payment_attrs['execution_date'] if @payment_attrs['execution_date']
        attributes['debited_account_id'] = @payment_attrs['debited_account_id'] if @payment_attrs['debited_account_id']
        attributes['debited_account_type'] = @payment_attrs['debited_account_type'] if @payment_attrs['debited_account_type']
        attributes['scheme'] = @payment_attrs['scheme'] if @payment_attrs['scheme']
        
        # Mandatory attributes => beneficiary
        if @payment_attrs['beneficiary']
          attributes['beneficiary'] = {
            name: @payment_attrs['beneficiary']['name'],
            street: @payment_attrs['beneficiary']['street'],
            zip: @payment_attrs['beneficiary']['zip'],
            city: @payment_attrs['beneficiary']['city'],
            country: @payment_attrs['beneficiary']['country'],
            iban: @payment_attrs['beneficiary']['iban'],
            swift_bic: @payment_attrs['beneficiary']['swift_bic']
          }

          # Optionals attributes => beneficiary
          attributes['beneficiary']['number'] = @payment_attrs['beneficiary']['number'] if @payment_attrs['beneficiary']['number']
          attributes['beneficiary']['complement'] = @payment_attrs['beneficiary']['complement'] if @payment_attrs['beneficiary']['complement']
          attributes['beneficiary']['form'] = @payment_attrs['beneficiary']['form'] if @payment_attrs['beneficiary']['form']
          attributes['beneficiary']['incorporation'] = @payment_attrs['beneficiary']['incorporation'] if @payment_attrs['beneficiary']['incorporation']
        end

        # Mandatory meta data
        meta = {
            psu_name: @payment_attrs['customer_full_name'],
            psu_email: @payment_attrs['customer_email'],
            psu_phone: @payment_attrs['customer_phone']
        }

        # Optionals meta data
        meta['psu_phone_prefix'] = @payment_attrs['customer_phone_prefix'] if @payment_attrs['customer_phone_prefix']
        meta['psu_ip'] = @payment_attrs['customer_ip'] if @payment_attrs['customer_ip']


        # Mandatory meta => psu_address
        meta['psu_address'] = {
          street:  @payment_attrs['customer_address']['street'], 
          city:  @payment_attrs['customer_address']['city'],
          zip: @payment_attrs['customer_address']['zip'],
          country: @payment_attrs['customer_address']['country'] 
        }

        # Optionals meta => psu_address
        meta['psu_address']['number'] = @payment_attrs['customer_address']['number'] if @payment_attrs['customer_address']['number']
        meta['psu_address']['complement'] = @payment_attrs['customer_address']['complement'] if @payment_attrs['customer_address']['complement']


        # Return the payload
        {
            meta: meta,
            data: {
              type: 'PIS',
              attributes: attributes,
          }
        }
      end

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