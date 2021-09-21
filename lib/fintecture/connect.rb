require 'base64'
require 'json'
require 'faraday'
require 'fintecture/pis'
require 'fintecture/utils/validation'
require 'fintecture/exceptions'
require 'fintecture/utils/date'
require 'fintecture/utils/constants'
require 'cgi'
module Fintecture
  class Connect
    class << self
      SIGNATURE_TYPE = 'rsa-sha256'.freeze

      def get_pis_connect(access_token = nil, payment_attrs = nil)
        connect_url(access_token, payment_attrs, type: 'pis')
      end


      # Main process for construct the request to get a connect url
      def connect_url(access_token = nil, payment_attrs = nil, type: nil)
        @access_token = access_token
        @payment_attrs = as_json payment_attrs
        @type = type

        # TODO Update verification payment before the request 
        # validate_payment_integrity

        @payment_attrs['end_to_end_id'] ||= Fintecture::Utils::Crypto.generate_uuid_only_chars
        @payment_attrs['amount'] = @payment_attrs['amount'].to_s

        payload = build_payload
        connect_response = connect access_token, payload
        connect_response_body = JSON.parse connect_response.body

        #TODO add try catch if response is not ok
        # puts '
        #   Response
        # '
        # puts connect_response_body

        {
            url: connect_response_body['meta']['url'],
            session_id: connect_response_body['meta']['session_id']
        }
      end


      # Api call for get a connect url
      def connect(access_token, payload)

        url = connect_endpoint
        # params["state"] = @payment_attrs['state']
        # params["redirect_uri"] = @payment_attrs['redirect_uri']

      

        # TODO Wrong way to add params i think
        # params = URI.encode_www_form params
        params = CGI.unescape "?state='#{@payment_attrs['state']}'&redirect_uri='#{@payment_attrs['redirect_uri']}'".to_s


        query_string = "?#{{
          state:  @payment_attrs['state'],
          # redirect_uri: @payment_attrs['redirect_uri']
          
        }.map{|key, value| "#{key}=#{value}"}.join('&')}"

        puts "
        URI: #{ url + query_string}
        "
        Fintecture::Faraday::Authentication::Connection.post(
            url: url + query_string, 
            req_body: payload.to_json,
            custom_content_type: 'application/json',
            bearer: "Bearer #{access_token}",
            # TODO Re-activate security
            secure_headers: true
        )
      end

      # Build the endpoint for connect route
      def connect_endpoint
        "#{api_base_url}/#{Fintecture::Api::Endpoints::Pis::CONNECT}"
      end


      def api_base_url
        Fintecture::Api::BaseUrl::FINTECTURE_API_URL[Fintecture.environment.to_sym]
      end








      
      def verify_url_parameters(parameters = nil)
        @post_payment_attrs = as_json parameters

        validate_post_payment_integrity

        decrypted =  Fintecture::Utils::Crypto.decrypt_private @post_payment_attrs['s']
        local_digest = build_local_digest @post_payment_attrs

        decrypted == local_digest
      end

      private

      def build_url(config)
        "#{base_url}/#{@type}/#{@payment_attrs['psu_type']}/#{@payment_attrs['country']}?config=#{Base64.strict_encode64(config)}"
      end



      def validate_payment_integrity
        Fintecture::Utils::Validation.raise_if_klass_mismatch @payment_attrs, Hash, 'payment_attrs'

        raise Fintecture::ValidationException.new("access_token is a mandatory field") if @access_token.nil?

        @payment_attrs['psu_type'] = 'retail' unless @payment_attrs['psu_type']
        @payment_attrs['country'] = 'all' unless @payment_attrs['country']

        error_msg = 'invalid payment payload parameter'

        raise Fintecture::ValidationException.new("#{error_msg} type") unless Fintecture::Utils::Constants::SCOPES.include? @type
        raise Fintecture::ValidationException.new("#{@payment_attrs['psu_type']} PSU type not allowed") unless Fintecture::Utils::Constants::PSU_TYPES.include? @payment_attrs['psu_type']

        raise Fintecture::ValidationException.new('end_to_end_id must be an alphanumeric string') if(@payment_attrs['end_to_end_id'] && !@payment_attrs['end_to_end_id'].match(/^[0-9a-zA-Z]*$/))
        Fintecture::Utils::Validation.raise_if_invalid_date_format(@payment_attrs['execution_date']) if(@payment_attrs['execution_date'])

        %w[amount currency customer_full_name customer_email customer_ip redirect_uri].each do |param|
          raise Fintecture::ValidationException.new("#{param} is a mandatory field") if @payment_attrs[param].nil?
        end

        # Check if string
        %w[communication redirect_uri provider customer_phone].each do |param|
          Fintecture::Utils::Validation.raise_if_klass_mismatch(@payment_attrs[param], String, param) if(@payment_attrs[param])
        end

        # Check customer_address structure
        Fintecture::Utils::Validation.raise_if_klass_mismatch(@payment_attrs['customer_address'], Hash) if(@payment_attrs['customer_address'])

        raise Fintecture::ValidationException.new('customer_address country must be a 2 letters string') if(@payment_attrs['customer_address'] && @payment_attrs['customer_address']['country'] && !@payment_attrs['customer_address']['country'].match(/^[a-zA-Z]{2}$/))

        %w[street number complement zip city country].each do |param|
          Fintecture::Utils::Validation.raise_if_klass_mismatch(@payment_attrs['customer_address'][param], String, param) if(@payment_attrs['customer_address'] && @payment_attrs['customer_address'][param])
        end

        # Check beneficiary structure

        Fintecture::Utils::Validation.raise_if_klass_mismatch(@payment_attrs['beneficiary'], Hash) if(@payment_attrs['beneficiary'])

        %w[name street city iban swift_bic].each do |param|
          raise Fintecture::ValidationException.new("beneficiary #{param} is a mandatory field") if @payment_attrs['beneficiary'] && @payment_attrs['beneficiary'][param].nil?
        end

        raise Fintecture::ValidationException.new('beneficiary country must be a 2 letters string') if(@payment_attrs['beneficiary'] && @payment_attrs['beneficiary']['country'] && !@payment_attrs['beneficiary']['country'].match(/^[a-zA-Z]{2}$/))

        %w[name street number complement zip city country iban swift_bic bank_name].each do |param|
          Fintecture::Utils::Validation.raise_if_klass_mismatch(@payment_attrs['beneficiary'][param], String, param) if(@payment_attrs['beneficiary'] && @payment_attrs['beneficiary'][param])
        end
      end

      def validate_post_payment_integrity
        Fintecture::Utils::Validation.raise_if_klass_mismatch @post_payment_attrs, Hash, 'post_payment_attrs'

        %w[s state status session_id customer_id provider].each do |param|
          raise Fintecture::ValidationException.new("invalid post payment parameter #{param}") if @post_payment_attrs[param].nil?
        end
      end

      def build_payload
        attributes = {
            amount: @payment_attrs['amount'],
            currency: @payment_attrs['currency'],
            communication: @payment_attrs['communication'],
            end_to_end_id: @payment_attrs['end_to_end_id'],
            # execution_date: @payment_attrs['execution_date'],
            # provider: @payment_attrs['provider']
        }

        if @payment_attrs['beneficiary']
          attributes['beneficiary'] = {
            name: @payment_attrs['beneficiary']['name'],
            street: @payment_attrs['beneficiary']['street'],
            number: @payment_attrs['beneficiary']['number'],
            # complement: @payment_attrs['beneficiary']['complement'],
            zip: @payment_attrs['beneficiary']['zip'],
            city: @payment_attrs['beneficiary']['city'],
            country: @payment_attrs['beneficiary']['country'],
            iban: @payment_attrs['beneficiary']['iban'],
            swift_bic: @payment_attrs['beneficiary']['swift_bic'],
            # bank_name: @payment_attrs['beneficiary']['bank_name']
          }
        end

        meta = {
            psu_name: @payment_attrs['customer_full_name'],
            psu_email: @payment_attrs['customer_email'],
            psu_ip: @payment_attrs['customer_ip'],
            psu_phone: @payment_attrs['customer_phone'],
            psu_address: @payment_attrs['customer_address']
        }

        data = {
            type: 'PIS',
            attributes: attributes,
        }

        # prepare_payment_response = Fintecture::Pis.prepare_payment( @access_token, {
        #        data: data,
        #        meta: meta
        #   })
        # prepare_payment_response_body = JSON.parse(prepare_payment_response.body)
        # data_attributes = {amount: @payment_attrs['amount'], currency: @payment_attrs['currency']}
        # data_attributes[:execution_date] = @payment_attrs['execution_date'] if @payment_attrs['execution_date']
        # data_attributes[:beneficiary] = { name: @payment_attrs['beneficiary']['name'] } if @payment_attrs['beneficiary'] && @payment_attrs['beneficiary']['name']
        {
            meta: meta,
            data: data
        }
      end

      def build_signature(payload, date, x_request_id)
        date_string = "x-date: #{date}"
        digest_string = "digest: SHA-256=#{Fintecture::Utils::Crypto.hash_base64(payload.to_json)}"
        x_request_id_string = "x-request-id: #{x_request_id}"

        Fintecture::Utils::Crypto.sign_payload "#{digest_string}\n#{date_string}\n#{x_request_id_string}"
      end

      def build_config(payload)
        header_time = Fintecture::Utils::Date.header_time
        x_request_id = Fintecture::Utils::Crypto.generate_uuid
        config = {
            app_id: Fintecture.app_id,
            access_token: @access_token,
            date: header_time,
            request_id: x_request_id,
            signature_type: SIGNATURE_TYPE,
            signature: build_signature(payload, header_time, x_request_id),
            redirect_uri: @payment_attrs['redirect_uri'] || '',
            origin_uri: @payment_attrs['origin_uri'] || '',
            state: @payment_attrs['state'],
            payload: payload
        }
        config[:provider] = @payment_attrs['provider'] if @payment_attrs['provider']
        config
      end

      def build_local_digest(parameters)
        test_string = {
            app_id: Fintecture.app_id,
            app_secret: Fintecture.app_secret,
            session_id: parameters['session_id'],
            status: parameters['status'],
            customer_id: parameters['customer_id'],
            provider: parameters['provider'],
            state: parameters['state']
        }.map{|key, value| "#{key}=#{value}"}.join('&')

        Fintecture::Utils::Crypto.hash_base64 test_string
      end

      def base_url
        Fintecture::Api::BaseUrl::FINTECTURE_CONNECT_URL[Fintecture.environment.to_sym]
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